with cte_sfcc_main_image as (
    select
        SFCC_PRODUCT_ID
        , IMAGE_PATH as SFCC_IMAGE_URL
        , IMAGE_NAME
        , CLEARANCE_INDICATOR
    from
        {{ ref('stg_land__fbb_sfra_images') }} as sfi
    where
        sfi.VARIATION_VALUE is null
        and sfi.VIEW_TYPE = 'hi-res'
        and sfi.IS_FINAL_SALE = 0
    qualify
        row_number() over(partition by SFCC_PRODUCT_ID, CLEARANCE_INDICATOR order by sfi.IMAGE_CODE desc) = 1
),
cte_main_color_id as (
    select
        sfi.SFCC_PRODUCT_ID
        , sfi.VARIATION_VALUE as COLOR_ID
        , sfi.CLEARANCE_INDICATOR
    from
        {{ ref('stg_land__fbb_sfra_images') }} as sfi
        join cte_sfcc_main_image im on im.SFCC_PRODUCT_ID = sfi.SFCC_PRODUCT_ID and im.IMAGE_NAME = sfi.IMAGE_NAME
    where
        sfi.VIEW_TYPE = 'hi-res'
        and VARIATION_VALUE is not null
        and sfi.IS_FINAL_SALE = 0
    qualify
        row_number() over(partition by sfi.SFCC_PRODUCT_ID, sfi.CLEARANCE_INDICATOR order by sfi.SFCC_PRODUCT_ID) = 1
),
cte_amazon_main_image as (
    select
        pim.PRODUCT_ID
        , br.BRAND_ID
        , br.MILENNA_IMAGE_URL || im.IMAGE_CODE || '/' || im.IMAGE_NAME  as AMAZON_IMAGE_URL
    from
        {{ ref('stg_land__fbb_images') }} as im
        inner join {{ ref('stg_land__fbb_product_images') }} as pim on im.IMAGE_ID = pim.IMAGE_ID
        inner join {{ ref('stg_land__fbb_brands') }} as br on im.BRAND_ID = br.BRAND_ID
    where
        pim.IMAGE_TYPE_ID = 9
        and pim.STATUS = 1
),
cte_sfcc_color_image_path as (
    select
        sfi.SFCC_PRODUCT_ID
        , IMAGE_PATH as SFCC_IMAGE_URL
        , VARIATION_VALUE as COLOR_ID
        , sfi.CLEARANCE_INDICATOR
    from
        {{ ref('stg_land__fbb_sfra_images') }} as sfi
    where
        sfi.VIEW_TYPE = 'hi-res'
        and sfi.IMAGE_CODE = 'mc'
        and sfi.IS_FINAL_SALE = 0
),
cte_main_color as (
    select
        spr.SFCC_PRODUCT_ID
        , br.BRAND_ID
        , br.BRAND_CODE
        , br.IMAGE_DOMAIN
        , st.CLEARANCE_INDICATOR
        , ( {{ get_sfcc_color_image('spr.SFCC_PRODUCT_ID', 'st.CLEARANCE_INDICATOR') }} ) as SFCC_MAIN_COLOR
        , coalesce(cte_main_color_id.COLOR_ID, SFCC_MAIN_COLOR) as MAIN_COLOR_ID
        , cte_sfcc_main_image.SFCC_IMAGE_URL as SFCC_MAIN_IMAGE_URL
        , spr.URL as SPR_URL
    from
        {{ ref('stg_land__fbb_sfra_products') }} as spr
        join {{ ref('stg_land__fbb_products') }} as pr on left(spr.SFCC_PRODUCT_ID, 7) = pr.PRODUCT_ID
        join {{ ref('stg_land__fbb_styles') }} as st on pr.PRODUCT_ID = st.PRODUCT_ID
        join {{ ref('stg_land__fbb_brands') }} as br on pr.BRAND_ID = br.BRAND_ID
        left join cte_sfcc_main_image on spr.SFCC_PRODUCT_ID = cte_sfcc_main_image.SFCC_PRODUCT_ID and st.CLEARANCE_INDICATOR = cte_sfcc_main_image.CLEARANCE_INDICATOR
        left join cte_main_color_id on cte_main_color_id.SFCC_PRODUCT_ID = spr.SFCC_PRODUCT_ID and st.CLEARANCE_INDICATOR = cte_main_color_id.CLEARANCE_INDICATOR
    where
        MAIN_COLOR_ID is not null
    qualify
        row_number() over(partition by spr.SFCC_PRODUCT_ID, br.BRAND_CODE order by spr.SFCC_PRODUCT_ID, st.CLEARANCE_INDICATOR) = 1
)
select
    cte_main_color.SFCC_PRODUCT_ID
    , cte_main_color.BRAND_CODE
    , cte_main_color.CLEARANCE_INDICATOR
    , cte_main_color.MAIN_COLOR_ID
    , case when
        regexp_instr(coalesce(cami.AMAZON_IMAGE_URL,
                              SFCC_MAIN_IMAGE_URL,
                              cscip.SFCC_IMAGE_URL), 's3\\\.') = 0
    then
        cte_main_color.IMAGE_DOMAIN || coalesce(imu.RELATIVE_URL,
                                    substring(coalesce(cami.AMAZON_IMAGE_URL,
                                                       SFCC_MAIN_IMAGE_URL,
                                                       cscip.SFCC_IMAGE_URL),
                                                       regexp_instr(SPR_URL, '\\\.com/') + 4))
    else
        coalesce(cami.AMAZON_IMAGE_URL, SFCC_MAIN_IMAGE_URL, cscip.SFCC_IMAGE_URL)
    end as MAIN_IMAGE_URL
    , cte_main_color.IMAGE_DOMAIN || substring(SFCC_MAIN_IMAGE_URL, regexp_instr(SPR_URL, '\\\.com/') + 4) as SFCC_MAIN_IMAGE_URL
from
    cte_main_color
    left join cte_sfcc_color_image_path as cscip
        on cte_main_color.SFCC_PRODUCT_ID = cscip.SFCC_PRODUCT_ID
               and cte_main_color.SFCC_MAIN_COLOR = cscip.COLOR_ID
               and cte_main_color.CLEARANCE_INDICATOR = cscip.CLEARANCE_INDICATOR
    left join cte_amazon_main_image as cami
        on left(cte_main_color.SFCC_PRODUCT_ID, 7) = cami.PRODUCT_ID
               and cte_main_color.BRAND_ID = cami.BRAND_ID
    left join {{ ref('stg_land__fbb_sfra_image_urls') }} as imu
        on cte_main_color.SFCC_PRODUCT_ID = imu.SFCC_PRODUCT_ID
               and imu.TYPE = 'hi-res'
               and imu.VARIATION_VALUE = cte_main_color.MAIN_COLOR_ID

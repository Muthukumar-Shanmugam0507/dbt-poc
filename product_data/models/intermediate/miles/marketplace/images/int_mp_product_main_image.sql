with sfccmainimage as (
    select
        SFCC_PRODUCT_ID
        , IMAGE_PATH as SFCC_IMAGE_URL
        , IMAGE_NAME
    from
        {{ ref('stg_land__fbb_sfra_images') }} as sfi
    where
        sfi.VARIATION_VALUE is null
        and sfi.VIEW_TYPE = 'hi-res'
        and sfi.CLEARANCE_INDICATOR in ('B', 'C')
        and sfi.IS_FINAL_SALE = 0
    qualify
        row_number() over(partition by SFCC_PRODUCT_ID order by sfi.IMAGE_CODE desc) = 1
),
sfcccolorimage as (
    select
        SFCC_PRODUCT_ID
        , IMAGE_PATH as SFCC_IMAGE_URL
        , VARIATION_VALUE as COLOR_ID
    from
        {{ ref('stg_land__fbb_sfra_images') }} as sfi
    where
        sfi.VIEW_TYPE = 'hi-res'
        and sfi.IMAGE_CODE = 'mc'
        and sfi.CLEARANCE_INDICATOR in ('B', 'C')
        and sfi.IS_FINAL_SALE = 0
    qualify
        row_number() over(partition by SFCC_PRODUCT_ID order by SFCC_PRODUCT_ID) = 1
),
amazonmainimage as (
    select
        pim.PRODUCT_ID
        , br.BRAND_ID
        , br.MILENNA_IMAGE_URL || im.IMAGE_CODE || '/' || im.IMAGE_NAME  as AMAZON_IMAGE_URL
    from
        {{ ref('stg_land__mp_images') }} as im
        join {{ ref('stg_land__mp_product_images') }} as pim on im.IMAGE_ID = pim.IMAGE_ID
        join {{ ref('stg_land__mp_brands') }} as br on im.BRAND_ID = br.BRAND_ID
    where
        pim.IMAGE_TYPE_ID = 9
        and pim.STATUS = 1
),
maincolorid as (
    select
        sfi.SFCC_PRODUCT_ID
        , sfi.VARIATION_VALUE as COLOR_ID
    from
        {{ ref('stg_land__fbb_sfra_images') }} sfi
        join sfccmainimage im on im.SFCC_PRODUCT_ID = sfi.SFCC_PRODUCT_ID and im.IMAGE_NAME = sfi.IMAGE_NAME
    where
        sfi.VIEW_TYPE = 'hi-res'
        and VARIATION_VALUE is not null
        and sfi.CLEARANCE_INDICATOR in ('B', 'C')
        and sfi.IS_FINAL_SALE = 0
    qualify
        row_number() over(partition by sfi.SFCC_PRODUCT_ID order by sfi.SFCC_PRODUCT_ID) = 1
)

select
    p.SFCC_PRODUCT_ID
    , p.BRAND_CODE
    , p.CLEARANCE_INDICATOR
    , MAIN_IMAGE_URL
    , SFCC_MAIN_IMAGE_URL
    , MAIN_COLOR_ID
from (
    select
        spr.SFCC_PRODUCT_ID
        , br.BRAND_CODE
        , st.CLEARANCE_INDICATOR
        , case when
            regexp_instr(coalesce(amazonmainimage.AMAZON_IMAGE_URL,
                                  sfccmainimage.SFCC_IMAGE_URL,
                                  sfcccolorimage.SFCC_IMAGE_URL), 's3\\\.') = 0
        then
            br.IMAGE_DOMAIN || coalesce(
                                        imu.RELATIVE_URL,
                                        substring(coalesce(
                                                            amazonmainimage.AMAZON_IMAGE_URL, sfccmainimage.SFCC_IMAGE_URL,
                                                            sfcccolorimage.SFCC_IMAGE_URL),
                                                            regexp_instr(spr.URL, '\\\.com/') + 4))
        else
            coalesce(amazonmainimage.AMAZON_IMAGE_URL, sfccmainimage.SFCC_IMAGE_URL, sfcccolorimage.SFCC_IMAGE_URL)
        end as MAIN_IMAGE_URL
        , br.IMAGE_DOMAIN || substring(sfccmainimage.SFCC_IMAGE_URL, regexp_instr(spr.URL, '\\\.com/') + 4) as SFCC_MAIN_IMAGE_URL
        , coalesce(maincolorid.COLOR_ID, sfcccolorimage.COLOR_ID) as MAIN_COLOR_ID
    from
        {{ ref('stg_land__fbb_sfra_products') }} as spr
        join {{ ref('stg_land__mp_products') }} as pr on left (spr.SFCC_PRODUCT_ID, 7) = pr.PRODUCT_ID
        join {{ ref('stg_land__mp_styles') }} as st on pr.PRODUCT_ID = st.PRODUCT_ID
        cross join {{ ref('stg_land__mp_brands') }} as br
        left join sfccmainimage on spr.SFCC_PRODUCT_ID = sfccmainimage.SFCC_PRODUCT_ID
        left join maincolorid on maincolorid.SFCC_PRODUCT_ID = spr.SFCC_PRODUCT_ID
        left join sfcccolorimage on spr.SFCC_PRODUCT_ID = sfcccolorimage.SFCC_PRODUCT_ID
        left join amazonmainimage on pr.PRODUCT_ID = amazonmainimage.PRODUCT_ID and pr.BRAND_ID = amazonmainimage.BRAND_ID
        left join {{ ref('stg_land__fbb_sfra_image_urls') }} as imu on spr.SFCC_PRODUCT_ID = imu.SFCC_PRODUCT_ID
                                    and imu.TYPE = 'hi-res'
                                    and imu.VARIATION_VALUE = coalesce (maincolorid.COLOR_ID, sfcccolorimage.COLOR_ID)
    group by
        spr.SFCC_PRODUCT_ID
        , br.BRAND_CODE
        , st.CLEARANCE_INDICATOR
        , MAIN_IMAGE_URL
        , SFCC_MAIN_IMAGE_URL
        , MAIN_COLOR_ID
) as p

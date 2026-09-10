with sfccmainimage as (
    select
        SFCC_PRODUCT_ID
        , IMAGE_PATH as SFCC_IMAGE_URL
    from
        {{ ref('stg_land__fbb_sfra_images') }} as sfi
    qualify
        row_number() over(partition by SFCC_PRODUCT_ID order by IMAGE_CODE desc, IMAGE_PATH desc) = 1
),
sfcccolorimage as (
    select
        SFCC_PRODUCT_ID
        , IMAGE_PATH as SFCC_IMAGE_URL
    from
        {{ ref('stg_land__fbb_sfra_images') }} as sfi
    where
        sfi.VIEW_TYPE = 'hi-res'
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
        and pim.STATUS in (1, 2)
),
imgurl as (
    select
        spr.SFCC_PRODUCT_ID
        , pr.BRAND_ID
        , case when
            regexp_instr(coalesce(amazonmainimage.AMAZON_IMAGE_URL, sfccmainimage.SFCC_IMAGE_URL, sfcccolorimage.SFCC_IMAGE_URL), 's3\\\.') > 0
            then true
            else false
        end as IS_S3_IMAGE
        , case when 
            regexp_instr(coalesce(amazonmainimage.AMAZON_IMAGE_URL, sfccmainimage.SFCC_IMAGE_URL, sfcccolorimage.SFCC_IMAGE_URL), 's3\\\.') = 0
        then 
            substring(coalesce(amazonmainimage.AMAZON_IMAGE_URL, sfccmainimage.SFCC_IMAGE_URL, sfcccolorimage.SFCC_IMAGE_URL), regexp_instr(URL, '\\\.com/') + 4)
        else 
            coalesce(amazonmainimage.AMAZON_IMAGE_URL, sfccmainimage.SFCC_IMAGE_URL, sfcccolorimage.SFCC_IMAGE_URL)
        end as MAIN_IMAGE_URL,
        substring(sfccmainimage.SFCC_IMAGE_URL, regexp_instr(URL, '\\\.com/') + 4) as SFCC_MAIN_IMAGE_URL
    from
        {{ ref('stg_land__fbb_sfra_products') }} as spr
        join {{ ref('stg_land__mp_products') }} as pr on left(spr.SFCC_PRODUCT_ID, 7) = pr.PRODUCT_ID
        left join sfccmainimage on spr.SFCC_PRODUCT_ID = sfccmainimage.SFCC_PRODUCT_ID
        left join sfcccolorimage on spr.SFCC_PRODUCT_ID = sfcccolorimage.SFCC_PRODUCT_ID
        left join amazonmainimage on pr.PRODUCT_ID = amazonmainimage.PRODUCT_ID and pr.BRAND_ID = amazonmainimage.BRAND_ID
)
select
    SFCC_PRODUCT_ID
    , case when
        IS_S3_IMAGE then MAIN_IMAGE_URL
        else site.IMAGE_DOMAIN || MAIN_IMAGE_URL
    end as LARGE_IMAGE_URL
    , site.IMAGE_DOMAIN || SFCC_MAIN_IMAGE_URL as SFCC_LARGE_IMAGE_URL
from
    imgurl
    cross join {{ ref('stg_land__fbb_brands') }} as site
where
    site.BRAND_CODE = 'OS'

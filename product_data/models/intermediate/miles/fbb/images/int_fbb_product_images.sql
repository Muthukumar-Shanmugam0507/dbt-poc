with main_colors as (
    select distinct
        PRODUCT_ID
        , MAIN_IMAGE_URL
        , SFCC_MAIN_IMAGE_URL
        , MAIN_COLOR_ID
    from
        {{ ref('miles_fbb_styles') }}
    qualify ROW_NUMBER() over(partition by PRODUCT_ID order by PRODUCT_ID, MAIN_COLOR_ID) = 1
)

select
    ap.PRODUCT_ID
    , coalesce(ast.MAIN_IMAGE_URL, ast.SFCC_MAIN_IMAGE_URL) as THUMB_IMAGE
    , ohi.ON_HOVER_IMAGE_URL as ON_HOVER_IMAGE
    , case when
        sfpr.BROWSE_COUNT > 0
    then
        coalesce(ast.MAIN_IMAGE_URL, ast.SFCC_MAIN_IMAGE_URL) || '?colorid=' || ast.MAIN_COLOR_ID
    end as BROWSE_THUMB_IMAGE
    , case when
        sfpr.CLEARANCE_COUNT > 0
    then
        coalesce(ast.MAIN_IMAGE_URL, ast.SFCC_MAIN_IMAGE_URL) || '?colorid=' || ast.MAIN_COLOR_ID
    end as CLEARANCE_THUMB_IMAGE
    , case when
        coalesce(ast.MAIN_IMAGE_URL, ast.SFCC_MAIN_IMAGE_URL) is not null and sfpr.CLEARANCE_COUNT > 0
    then
        ON_HOVER_IMAGE_URL
    else null
    end as CLEARANCE_ON_HOVER_IMAGE
    , case when
        sfpr.FINAL_SALE_COUNT > 0
    then
        imgfs.IMAGE_URL || '?colorid=' || imgfs.COLOR_ID
    end as FINAL_SALE_THUMB_IMAGE
    , case when
        imgfs.IMAGE_URL is not null and sfpr.FINAL_SALE_COUNT > 0
    then
        ON_HOVER_IMAGE_URL
    else null
    end as FINAL_SALE_ON_HOVER_IMAGE
from
    {{ ref('int_active_products') }} as ap
    join {{ ref('stg_land__fbb_sfra_products') }} as sfpr on ap.PRODUCT_ID = sfpr.PRODUCT_ID
    join main_colors as ast on ap.PRODUCT_ID = ast.PRODUCT_ID
    left join {{ ref('int_fbb_on_hover_image') }} as ohi on ap.PRODUCT_ID = ohi.PRODUCT_ID and ap.BRAND_ID = ohi.BRAND_ID
    left join {{ ref('int_fbb_fs_main_image') }} as imgfs on ap.PRODUCT_ID = imgfs.PRODUCT_ID

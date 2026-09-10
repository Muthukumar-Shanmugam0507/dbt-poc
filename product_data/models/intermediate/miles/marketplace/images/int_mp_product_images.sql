with main_colors as (
    select distinct
        PRODUCT_ID
        , LARGE_IMAGE
        , COLOR_ID
    from
        {{ ref('miles_mp_styles') }}
    qualify row_number() over(partition by PRODUCT_ID order by PRODUCT_ID, COLOR_ID) = 1
)
select
    ap.PRODUCT_ID
    , ast.LARGE_IMAGE as THUMB_IMAGE
    , THUMB_IMAGE || '?colorid=' || ast.COLOR_ID as BROWSE_THUMB_IMAGE
    , ohi.ON_HOVER_IMAGE_URL as ON_HOVER_IMAGE
from
    {{ ref('int_mp_active_products') }} as ap
    join main_colors as ast on ap.PRODUCT_ID = ast.PRODUCT_ID
    left join {{ ref('int_mp_on_hover_image') }} as ohi on ap.PRODUCT_ID = ohi.PRODUCT_ID and ap.BRAND_ID = ohi.BRAND_ID

{% macro get_daily_variants(prefix) %}
select distinct
    stc.BRAND_CODE
    , stc.PRODUCT_ID
    , stc.COLOR_ID
    , stc.PRODUCT_ID || '_' || stc.COLOR_ID as VARIANT_ID
    , max(stc.COLOR) as COLOR_NAME
    , max(stc.TITLE) as TITLE
    , max(stc.MS_DESCRIPTION) as DESCRIPTION
    , max(stc.IMAGE_URL) as IMAGE_URL
    , max(stc.PRODUCT_URL) as PRODUCT_URL
    , iff(max(mcp.CATEGORY_ID) is not null, true, false) as IS_LIVE
    , iff(sum(stc.QUANTITY) + sum(stc.BACKORDER_QUANTITY) > 0, true, false) as HAS_INVENTORY
from
    {{ref('int_' ~ prefix ~ '_styles_joined_with_colors')}} as stc
    left join {{ref('miles_category_products')}} as mcp on stc.PRODUCT_ID::varchar = mcp.PRODUCT_ID::varchar
where
    stc.STYLE_STATUS = 1
    and stc.SIZE_STATUS = 1
    and stc.PRICE_STATUS = 1
    and stc.PRODUCT_STATUS = 1
    and stc.INVENTORY_STATUS = 1
    and stc.COLOR_IMAGE_STATUS = 1
    and stc.IMAGE_TYPE_ID = 5
    and stc.TITLE is not null
group by
    stc.BRAND_CODE
    , stc.PRODUCT_ID
    , stc.COLOR_ID
    , stc.PRODUCT_ID || '_' || stc.COLOR_ID
{% endmacro %}
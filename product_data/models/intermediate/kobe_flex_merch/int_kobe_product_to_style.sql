select
    pr.BRAND_ID as OWNING_BRAND_ID
    , br.BRAND_NAME as OWNING_BRAND
    , br.BRAND_CODE
    , st.SELLING_DEPARTMENT as DEPARTMENT
    , pr.PCM_BRAND
    , st.PRODUCT_ID as SF_PRODUCT_ID
    , pr.MF_MASTER_ITEM_ID as MF_PRODUCT_ID
    , st.COLOR_ID as SF_COLOR_ID
    , st.MF_STYLE_ID as MF_COLOR_ID
    , st.STYLE_ID
    , pr.TITLE
    , pr.MF_TITLE
    , pr.MS_DESCRIPTION as DESCRIPTION
    , st.COLOR
    , sku.COLOR_SORT_ORDER
    , ( {{ get_product_url('st.PRODUCT_ID', 'br.BRAND_CODE') }}) as PRODUCT_URL
    , ( {{ get_product_url('st.PRODUCT_ID', 'br.BRAND_CODE') }}) || '?dwvar_' || st.PRODUCT_ID || '_color=' || st.COLOR_ID AS PRODUCT_COLOR_URL
    , iff(mcp.CATEGORY_ID is not null, true, false) as IS_LIVE
    , iff(pr.FULFILLMENT_INDICATOR = 2, true, false) as IS_DROPSHIP
from
    {{ ref('stg_land__fbb_products') }} as pr
    join {{ ref('stg_land__fbb_styles') }} as st on pr.product_id = st.product_id and pr.mf_master_item_id = st.mf_item_id
    join {{ ref('stg_land__fbb_brands') }} as br on pr.BRAND_ID = br.BRAND_ID
    left join {{ref('miles_category_products')}} as mcp on st.PRODUCT_ID::varchar = mcp.PRODUCT_ID::varchar
    left join {{ref('stg_land__fbb_color_sort_order_skus')}} as sku on st.PRODUCT_ID::varchar = sku.PRODUCT_ID::varchar and st.COLOR_ID = sku.COLOR_ID
where
    pr.STATUS = 1
    and st.STATUS = 1
    and pr.TITLE is distinct from ''
    and pr.TITLE is not null
group by
    pr.BRAND_ID
    , br.BRAND_NAME
    , br.BRAND_CODE
    , st.SELLING_DEPARTMENT
    , pr.PCM_BRAND
    , st.PRODUCT_ID
    , pr.MF_MASTER_ITEM_ID
    , st.COLOR_ID
    , st.MF_STYLE_ID
    , STYLE_ID
    , TITLE
    , MF_TITLE
    , pr.MS_DESCRIPTION
    , st.COLOR
    , sku.COLOR_SORT_ORDER
    , IS_LIVE
    , pr.FULFILLMENT_INDICATOR
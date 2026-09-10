select
    pr.BRAND_ID
    , br.BRAND_CODE
    , br.BRAND_NAME
    , pr.TITLE
    , st.PRODUCT_ID
    , pr.MF_MASTER_ITEM_ID
    , pr.CLASSIFICATION_ID
    , pr.SFFC_CATEGORY_ID
    , pr.MS_DESCRIPTION
    , pr.PCM_BRAND
    , pr.PCM_SEO_DESCRIPTION
    , pr.CUSTOMER_REVIEW_COUNT
    , pr.CUSTOMER_REVIEW_AVERAGE
    , st.MF_ITEM_ID
    , st.STYLE_ID
    , st.MF_STYLE_ID
    , st.STYLE_TYPE
    , st.COLOR_ID
    , st.COLOR
    , st.IS_PRINT
    , sz.SIZE_ID
    , sz.MF_SIZE_ID
    , sz.DISPLAY_SIZE
    , sz.OFFERED_SIZE
    , sz.SIZE_SEQUENCE
    , sz.WAS_PRICE
    , st.SELLING_DEPARTMENT
    , pc.MEDIA_KEY
    , pc.SELLING_PRICE
    , pc.SELLING_PRICE_START_DATE
    , pc.SELLING_PRICE_END_DATE
    , img.IMAGE_URL
    , ( {{ get_product_url('st.PRODUCT_ID', 'br.BRAND_CODE') }}) || '?dwvar_' || st.PRODUCT_ID || '_color=' || st.COLOR_ID AS PRODUCT_URL
    , inv.QUANTITY
    , inv.BACKORDER_QUANTITY
    , inv.NEXT_AVAILABLE_DATE
    , st.STATUS as STYLE_STATUS
    , sz.STATUS as SIZE_STATUS
    , pc.STATUS as PRICE_STATUS
    , pr.STATUS as PRODUCT_STATUS
    , inv.STATUS as INVENTORY_STATUS
    , cim.STATUS as COLOR_IMAGE_STATUS
    , img.STATUS as IMAGE_STATUS
    , cim.IMAGE_TYPE_ID as IMAGE_TYPE_ID
    , st.CLEARANCE_INDICATOR
    , st.IS_FINAL_SALE
    , pr.FULFILLMENT_INDICATOR
from
    {{ref('stg_land__fbb_styles')}} as st
    join {{ref('stg_land__fbb_sizes')}} as sz on sz.STYLE_ID = st.STYLE_ID
    join {{ref('stg_land__fbb_inventory')}} as inv on inv.SIZE_ID = sz.SIZE_ID
    join {{ref('stg_land__fbb_prices')}} as pc on pc.SIZE_ID = sz.SIZE_ID
    join {{ref('stg_land__fbb_products')}} as pr on pr.PRODUCT_ID = st.PRODUCT_ID
    join {{ref('stg_land__fbb_color_images')}} as cim on cim.COLOR_ID = st.COLOR_ID
    join {{ref('stg_land__fbb_images')}} as img on img.IMAGE_ID = cim.IMAGE_ID
    join {{ref('stg_land__fbb_brands')}} as br on pr.BRAND_ID = br.BRAND_ID
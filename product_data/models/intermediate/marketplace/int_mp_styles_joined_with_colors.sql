select
    pr.BRAND_ID
    , br.BRAND_CODE
    , pr.TITLE
    , st.PRODUCT_ID
    , pr.MF_MASTER_ITEM_ID
    , pr.CLASSIFICATION_ID
    , pr.VENDOR_ID
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
    , st.GENDER
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
    , ( {{ get_mp_product_url('st.PRODUCT_ID', 'br.BRAND_CODE') }}) || '?dwvar_' || st.PRODUCT_ID || '_color=' || st.COLOR_ID AS PRODUCT_URL
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
    , v.MP_VENDOR_ID
    , iff(VENDOR_GROUP = 'DIA', true, false) as IS_DIA
    , v.STATUS as VENDOR_STATUS
    , cim.IMAGE_TYPE_ID as IMAGE_TYPE_ID
    , v.ENABLED_PRODUCTION
    , pr.FULFILLMENT_INDICATOR
from
    {{ref('stg_land__mp_styles')}} as st
    join {{ref('stg_land__mp_sizes')}} as sz on sz.STYLE_ID = st.STYLE_ID
    join {{ref('stg_land__mp_inventory')}} as inv on inv.SIZE_ID = sz.SIZE_ID
    join {{ref('stg_land__mp_prices')}} as pc on pc.SIZE_ID = sz.SIZE_ID
    join {{ref('stg_land__mp_products')}} as pr on pr.PRODUCT_ID = st.PRODUCT_ID
    join {{ref('stg_land__mp_color_images')}} as cim on cim.COLOR_ID = st.COLOR_ID
    join {{ref('stg_land__mp_images')}} as img on img.IMAGE_ID = cim.IMAGE_ID
    join {{ref('stg_land__mp_brands')}} as br on pr.BRAND_ID = br.BRAND_ID
    join {{ref('stg_land__mp_vendors')}} as v on pr.VENDOR_ID = v.MF_VENDOR_ID

{% macro get_mp_active_products_key() %}
    md5(
        ifnull(ap.BRAND_ID, 'mp_product') ||
        ifnull(ap.BRAND_CODE, 'mp_product') ||
        ifnull(ap.PRODUCT_ID, 100) ||
        ifnull(ap.MF_MASTER_ITEM_ID, 'mp_product') ||
        ap.TITLE ||
        ifnull(ap.MS_DESCRIPTION, 'mp_product') ||
        ifnull(ap.PCM_BRAND, 'mp_product') ||
        ifnull(ap.MP_VENDOR_ID, 'mp_product') ||
        ifnull(ap.IS_DIA, false) ||
        ifnull(ap.PCM_SEO_DESCRIPTION, 'mp_product') ||
        ifnull(ap.CUSTOMER_REVIEW_COUNT, 0) ||
        ifnull(ap.CUSTOMER_REVIEW_AVERAGE, 0) ||
        ifnull(ap.GENDER, 'mp_product') ||
        ifnull(PRODUCT_URL, 'mp_product') ||
        ifnull(tx.DIVISION, 'mp_product') ||
        ifnull(tx.CATEGORY, 'mp_product') ||
        ifnull(tx.SUBCATEGORY, 'mp_product')
    )
{% endmacro %}

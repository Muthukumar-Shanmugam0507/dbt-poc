{% macro get_active_products_key() %}
    md5(
        ifnull(ap.BRAND_ID, 'product') ||
        ifnull(ap.BRAND_CODE, 'product') ||
        ifnull(ap.PRODUCT_ID, 100) ||
        ifnull(ap.MF_MASTER_ITEM_ID, 'product') ||
        ap.TITLE ||
        ifnull(ap.MS_DESCRIPTION, 'product') ||
        ifnull(ap.PCM_BRAND, 'product') ||
        ifnull(ap.PCM_SEO_DESCRIPTION, 'product') ||
        ifnull(ap.CUSTOMER_REVIEW_COUNT, 0) ||
        ifnull(ap.CUSTOMER_REVIEW_AVERAGE, 0) ||
        ifnull(PRODUCT_URL, 'product') ||
        ifnull(tx.DIVISION, 'product') ||
        ifnull(tx.CATEGORY, 'product') ||
        ifnull(tx.SUBCATEGORY, 'product')
    )
{% endmacro %}

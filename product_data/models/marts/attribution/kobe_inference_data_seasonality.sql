WITH ai_attributed_product_ids AS (
    SELECT
        PRODUCT_ID,
        BRAND_CODE,
        SEASONALITY
    FROM
        {{ source('BEYONSEE_AI_ATTRIBUTION', 'SEASONALITY_MAPPING_BEYONSEE') }}
)
SELECT
    fp.BRAND_ID,
    fp.MF_MASTER_ITEM_ID AS MF_PRODUCT_ID,
    fp.PRODUCT_ID,
    fp.BRAND_CODE,
    fp.IMAGE_URL,
    'FBB' AS SOURCE,
    fp.TITLE,
    fp.MS_DESCRIPTION,
    fp.PRODUCT_URL AS WEBSITE,
    CURRENT_DATE() AS DATE_CREATED
FROM
    {{ ref('fbb_active_products') }} AS fp
WHERE
    fp.PRODUCT_ID NOT IN (
        SELECT
            distinct PRODUCT_ID
        FROM
            ai_attributed_product_ids
    )
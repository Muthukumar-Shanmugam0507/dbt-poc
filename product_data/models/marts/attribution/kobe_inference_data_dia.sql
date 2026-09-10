WITH product_ids_with_five_or_more_attributes AS (
    SELECT
        PRODUCT_ID
    FROM
        {{ ref('stg_pdm__product_attributes') }}
    GROUP BY
        PRODUCT_ID
    HAVING
        COUNT(*) >= 5
),
ai_attributed_product_ids_with_five_or_more_attributes AS (
    SELECT
        PRODUCT_ID
    FROM
        {{ source('AI_KOBE', 'AI_ATTRIBUTION') }}
    GROUP BY
        PRODUCT_ID
    HAVING
        COUNT(*) >= 5
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
    {{ ref('mp_active_products') }} AS fp
WHERE
    fp.IS_DIA = TRUE
    AND fp.PRODUCT_ID NOT IN (
        SELECT
            distinct PRODUCT_ID
        FROM
            product_ids_with_five_or_more_attributes
    )
    AND fp.PRODUCT_ID NOT IN (
        SELECT
            distinct PRODUCT_ID
        FROM
            ai_attributed_product_ids_with_five_or_more_attributes
    )

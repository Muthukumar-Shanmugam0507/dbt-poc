WITH ai_attributed_variant_ids AS (
    SELECT
        PRODUCT_ID,
        COLOR_ID,
        BRAND_CODE
    FROM
        {{ source('BEYONSEE_AI_ATTRIBUTION', 'PRODUCT_VARIATIONS_GENERIC_COLORS') }}
)
SELECT
    fp.BRAND_ID,
    fp.PRODUCT_ID,
    fp.COLOR_ID,
    fp.BRAND_CODE,
    fp.IMAGE_URL,
    'FBB' AS SOURCE,
    fp.TITLE,
    fp.MS_DESCRIPTION,
    fp.PRODUCT_URL AS WEBSITE,
    CURRENT_DATE() AS DATE_CREATED
FROM
    {{ ref('fbb_active_variations') }} AS fp
WHERE NOT EXISTS (
    SELECT 1
    FROM ai_attributed_variant_ids a
    WHERE a.PRODUCT_ID = fp.PRODUCT_ID
      AND a.COLOR_ID = fp.COLOR_ID
      AND a.BRAND_CODE = fp.BRAND_CODE
)
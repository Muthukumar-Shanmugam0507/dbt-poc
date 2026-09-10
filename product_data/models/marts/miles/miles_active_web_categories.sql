select distinct
    awc.CATEGORY_ID
    , awc.NAME
    , awc.BRAND_ID
    , awc.PARENT_ID
    , awc.HIDE_MASTER_PRODUCT_IN_SLICING
from
    {{ ref('int_miles_active_web_categories') }} as awc
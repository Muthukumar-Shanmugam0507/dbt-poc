select distinct
    iff(ANCESTOR_CATEGORY_ID = 'root', 'Global', ANCESTOR_CATEGORY_ID) as CATEGORY_ID
    , ct.ANCESTOR_NAME as NAME
    , ct.BRAND_ID
    , iff(ct.PARENT_ID = 'root', 'Global', ct.PARENT_ID) as PARENT_ID
    , ct.HIDE_MASTER_PRODUCT_IN_SLICING
from
    {{ ref('int_category_tree') }} as ct
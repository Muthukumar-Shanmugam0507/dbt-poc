select
    kfv.OWNING_BRAND_ID as EFFORT
    , kfv.OWNING_BRAND
    , kfv.BRAND_CODE
    , kfv.DEPARTMENT
    , kfv.PCM_BRAND as BRAND_LABEL
    , dep.CATEGORY
    , dep.SUBCATEGORY
    , kfv.SF_PRODUCT_ID::varchar as SF_PRODUCT_ID
    , kfv.MF_PRODUCT_ID as MF_ID
    , kfv.MF_ITEM_IDS
    , kfv.SF_COLOR_ID::varchar as SF_COLOR_ID
    , kfv.MF_COLOR_ID as STYLE_IDS
    , kfv.TITLE
    , kfv.MF_TITLE
    , kfv.DESCRIPTION
    , kfv.COLOR as COLOR_NAME
    , kfv.COLOR_SORT_ORDER as COLOR_SORT
    , kfv.PRODUCT_URL
    , kfv.PRODUCT_COLOR_URL
    , kfv.HAS_INVENTORY
    , kfv.IS_LIVE
    , kfv.IS_SLICE
    , kfv.IS_DROPSHIP
from
    {{ ref('int_kobe_fbb_style_to_color') }} as kfv
    left join {{ ref('int_kobe_flex_fbb_departments') }} as dep on kfv.MF_PRODUCT_ID = dep.MF_ID and kfv.OWNING_BRAND_ID || kfv.DEPARTMENT = dep.DIVISION_DEPT
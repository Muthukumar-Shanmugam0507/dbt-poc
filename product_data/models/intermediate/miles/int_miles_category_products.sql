select distinct
    sz.PRODUCT_ID
    , c.BRAND_ID
    , c.CATEGORY_ID
    , c.NAME as CATEGORY_NAME
    , ( {{ get_product_url('sz.PRODUCT_ID', 'c.BRAND_ID') }} ) as PRODUCT_URL
    , coalesce(pj.PARENT_CATEGORIES, parse_json('[]')) as PARENT_CATEGORIES
from
    {{ ref('int_miles_active_web_categories') }} as c
    join {{ ref('stg_land__fbb_sfra_category_products') }} as cp on c.CATEGORY_ID = cp.CATEGORY_ID
    join {{ ref('int_eligible_product_ids') }} as sz on cp.PRODUCT_ID = sz.PRODUCT_ID
    left join {{ ref('int_miles_parent_categories') }} as pj on pj.LEAF_CATEGORY_ID = c.CATEGORY_ID

union

select distinct
    ps.PRODUCT_SET_ID as PRODUCT_ID
    , c.BRAND_ID
    , c.CATEGORY_ID
    , c.NAME as CATEGORY_NAME
    , ( {{ get_product_url('ps.PRODUCT_SET_ID', 'c.BRAND_ID') }} ) as PRODUCT_URL
    , coalesce(pj.PARENT_CATEGORIES, parse_json('[]')) as PARENT_CATEGORIES
from
    {{ ref('int_miles_active_web_categories') }} as c
    join {{ ref('stg_land__fbb_sfra_category_products') }} as cp on c.CATEGORY_ID = cp.CATEGORY_ID
    join {{ ref('int_eligible_product_set_ids') }} as ps on cp.SFCC_PRODUCT_ID = ps.PRODUCT_SET_ID
    left join {{ ref('int_miles_parent_categories') }} as pj on pj.LEAF_CATEGORY_ID = c.CATEGORY_ID

union

select distinct
    sps.SPECIAL_PRODUCT_SET_ID as PRODUCT_ID
    , c.BRAND_ID
    , c.CATEGORY_ID
    , c.NAME as CATEGORY_NAME
    , ( {{ get_product_url('sps.SPECIAL_PRODUCT_SET_ID', 'c.BRAND_ID') }} ) as PRODUCT_URL
    , coalesce(pj.PARENT_CATEGORIES, parse_json('[]')) as PARENT_CATEGORIES
from
    {{ ref('int_miles_active_web_categories') }} as c
    join {{ ref('stg_land__fbb_sfra_category_products') }} as cp on c.CATEGORY_ID = cp.CATEGORY_ID
    join {{ ref('int_eligible_special_product_set_ids') }} as sps on cp.SFCC_PRODUCT_ID = sps.SPECIAL_PRODUCT_SET_ID
    left join {{ ref('int_miles_parent_categories') }} as pj on pj.LEAF_CATEGORY_ID = c.CATEGORY_ID

union

select distinct
    concat(sl.PRODUCT_ID, '_', sl.COLOR_ID) as PRODUCT_ID
    , c.BRAND_ID
    , c.CATEGORY_ID
    , c.NAME as CATEGORY_NAME
    , ( {{ get_product_url('sl.PRODUCT_ID', 'c.BRAND_ID') }} ) || '?dwvar_' ||sl.PRODUCT_ID || '_color=' || sl.COLOR_ID AS PRODUCT_URL
    , coalesce(pj.parent_categories, parse_json('[]')) as PARENT_CATEGORIES
from
    {{ ref('int_miles_active_web_categories') }} as c
    join {{ ref('stg_land__fbb_sfra_category_product_splits') }} as cp on c.CATEGORY_ID = cp.CATEGORY_ID
    join {{ ref('int_eligible_slice_ids') }} as sl on cp.PRODUCT_ID = sl.PRODUCT_ID and cp.COLOR_ID = sl.COLOR_ID
    left join {{ ref('int_miles_parent_categories') }} as pj on pj.LEAF_CATEGORY_ID = c.CATEGORY_ID

union

select distinct
    gc.GIFT_CARD_ID as PRODUCT_ID
    , c.BRAND_ID
    , c.CATEGORY_ID
    , c.NAME as CATEGORY_NAME
    , ( {{ get_product_url('gc.GIFT_CARD_ID', 'c.BRAND_ID') }} ) as PRODUCT_URL
    , coalesce(pj.parent_categories, parse_json('[]')) as PARENT_CATEGORIES
from
    {{ ref('int_miles_active_web_categories') }} as c
    join {{ ref('stg_land__fbb_sfra_category_products') }} as cp on c.CATEGORY_ID = cp.CATEGORY_ID
    join {{ ref('stg_land__fbb_gift_cards') }} as gc on cp.PRODUCT_ID = gc.GIFT_CARD_ID
    left join {{ ref('int_miles_parent_categories') }} as pj on pj.LEAF_CATEGORY_ID = c.CATEGORY_ID
where
    gc.STATUS = 1
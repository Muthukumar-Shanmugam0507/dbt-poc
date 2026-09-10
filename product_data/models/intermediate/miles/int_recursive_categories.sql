with recursive_category as (
    select 
        CATEGORY_ID
        , PARENT as PARENT_ID
        , DISPLAY_NAME
        , cat.BRAND_ID
        , HIDE_MASTER_PRODUCT_IN_SLICING
        , CATEGORY_ID::TEXT as CAREGORY_PATH
        , DISPLAY_NAME as CAREGORY_NAME
        , 0 as LEVEL
        , array_construct(
            object_construct('id', CATEGORY_ID, 'name', br.BLOOMREACH_BRAND_NAME)
        ) as PARENT_CATEGORIES
    from
        {{ ref('stg_land__fbb_sfra_categories') }} as cat
        join {{ ref('stg_land__fbb_brands') }} as br on cat.BRAND_ID = br.BRAND_CODE
    where 
        PARENT_ID = 'root'

    union all

    select 
        c.CATEGORY_ID
        , c.PARENT_ID
        , c.NAME as DISPLAY_NAME
        , c.BRAND_ID
        , c.HIDE_MASTER_PRODUCT_IN_SLICING
        , concat(rc.CAREGORY_PATH, ' > ', c.CATEGORY_ID)::TEXT as CAREGORY_PATH
        , concat(rc.CAREGORY_NAME, ' > ', c.NAME)::TEXT as CAREGORY_NAME
        , rc.LEVEL + 1 as LEVEL
        , array_cat(
            rc.PARENT_CATEGORIES
            , array_construct(
                object_construct('id', c.CATEGORY_ID, 'name', c.NAME)
            )
        ) as PARENT_CATEGORIES
    from 
        {{ ref('miles_active_web_categories') }} as c
        join recursive_category rc ON c.PARENT_ID = rc.CATEGORY_ID
)
select 
    CATEGORY_ID
    , PARENT_ID
    , DISPLAY_NAME
    , BRAND_ID
    , HIDE_MASTER_PRODUCT_IN_SLICING
    , CAREGORY_PATH
    , CAREGORY_NAME
    , PARENT_CATEGORIES
from 
    recursive_category
ORDER BY
    LEVEL
    , CAREGORY_PATH

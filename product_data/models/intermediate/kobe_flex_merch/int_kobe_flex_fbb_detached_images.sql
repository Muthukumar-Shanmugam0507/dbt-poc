with cte_fbb_images as (
    select
        IMAGE_ID
        , IMAGE_TYPE_ID
        , IMAGE_NAME
        , IMAGE_URL
        , BRAND_ID
        , MF_ITEM_ID
        , MF_DEPARTMENT_ID
        , nullif(replace(MF_STYLE_ID, chr(0), ''), '') as MF_STYLE_ID
    from
        {{ ref('stg_land__fbb_images') }}
    where
        IMAGE_TYPE_ID in (1,3,4,5) -- We need mm, ma, mb, mc
)
, cte_product_detached_images as (
    select
        pri.IMAGE_ID
        , pri.PRODUCT_ID
        , pri.IMAGE_TYPE_ID
        , fim.IMAGE_NAME
        , fim.IMAGE_URL
        , fim.BRAND_ID
        , fim.MF_ITEM_ID
        , fim.MF_DEPARTMENT_ID
        , fim.MF_STYLE_ID
    from
        {{ ref('stg_land__fbb_product_images') }} as pri
        join cte_fbb_images as fim on (pri.IMAGE_ID = fim.IMAGE_ID
                                           and pri.IMAGE_TYPE_ID = fim.IMAGE_TYPE_ID)
    where
        pri.STATUS = 3 --detached images status
)
, cte_color_detached_images as (
    select
        fci.IMAGE_ID
        , fci.COLOR_ID
        , fci.IMAGE_TYPE_ID
        , fim.IMAGE_NAME
        , fim.IMAGE_URL
        , fim.BRAND_ID
        , fim.MF_ITEM_ID
        , fim.MF_DEPARTMENT_ID
        , fim.MF_STYLE_ID
    from
        {{ ref('stg_land__fbb_color_images') }} as fci
        join cte_fbb_images as fim on (fci.IMAGE_ID = fim.IMAGE_ID
                                           and fci.IMAGE_TYPE_ID = fim.IMAGE_TYPE_ID)
    where
        fci.STATUS = 3 --detached images status
)
, cte_flex_products as (
    select
        distinct
        SF_PRODUCT_ID
    from
        {{ ref('kobe_flex_fbb_variants') }}
    where
        not IS_DROPSHIP
)
, cte_flex_variants as (
    select
        SF_COLOR_ID
    from
        {{ ref('kobe_flex_fbb_variants') }}
    where
        not IS_DROPSHIP
)
, cte_detached_flex_images as (
    select
        pdi.IMAGE_ID
        , pdi.IMAGE_TYPE_ID
        , pdi.IMAGE_NAME
        , pdi.IMAGE_URL
        , pdi.PRODUCT_ID
        , null as COLOR_ID
        , pdi.BRAND_ID
        , pdi.MF_DEPARTMENT_ID
        , pdi.MF_ITEM_ID
        , pdi.MF_STYLE_ID
    from
        cte_product_detached_images as pdi
        join cte_flex_products as fpr on pdi.PRODUCT_ID = fpr.SF_PRODUCT_ID
    union
    select
        cdi.IMAGE_ID
        , cdi.IMAGE_TYPE_ID
        , cdi.IMAGE_NAME
        , cdi.IMAGE_URL
        , null as PRODUCT_ID
        , cdi.COLOR_ID
        , cdi.BRAND_ID
        , cdi.MF_DEPARTMENT_ID
        , cdi.MF_ITEM_ID
        , cdi.MF_STYLE_ID
    from
        cte_color_detached_images as cdi
        join cte_flex_variants as fvr on cdi.COLOR_ID = fvr.SF_COLOR_ID
)
select
    IMAGE_ID
    , IMAGE_TYPE_ID
    , IMAGE_NAME
    , IMAGE_URL
    , array_agg(distinct PRODUCT_ID) within group (order by PRODUCT_ID asc) as PRODUCT_IDS
    , array_agg(distinct COLOR_ID) within group (order by COLOR_ID asc) as COLOR_IDS
    , BRAND_ID
    , MF_DEPARTMENT_ID
    , MF_ITEM_ID
    , MF_STYLE_ID
from
    cte_detached_flex_images
group by
    IMAGE_ID
    , IMAGE_TYPE_ID
    , IMAGE_NAME
    , BRAND_ID
    , MF_DEPARTMENT_ID
    , MF_ITEM_ID
    , MF_STYLE_ID
    , IMAGE_URL
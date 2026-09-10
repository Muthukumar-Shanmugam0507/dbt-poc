with
{% set variations_common = [
    {'clearance_indicator': 'B', 'is_final_sale': 0},
    {'clearance_indicator': 'C', 'is_final_sale': 0}
] %}
{% set variations_common_asc = [
    {'clearance_indicator': 'B', 'is_final_sale': 0, 'ascending': 1},
    {'clearance_indicator': 'C', 'is_final_sale': 0, 'ascending': 1}
] %}
{% set variations_with_fs = [
    {'clearance_indicator': 'B', 'is_final_sale': 0},
    {'clearance_indicator': 'C', 'is_final_sale': 0},
    {'clearance_indicator': 'C', 'is_final_sale': 1}
] %}
{% set variations_with_fs_asc = [
    {'clearance_indicator': 'B', 'ascending': 1},
    {'clearance_indicator': 'C', 'is_final_sale': 0, 'ascending': 1},
    {'clearance_indicator': 'C', 'is_final_sale': 1, 'ascending': 1}
] %}
{% set variations_fs_limit = [{'is_final_sale': 1, 'limit': 5}] %}
{% set variations_fs_limit_asc = [{'is_final_sale': 1, 'limit': 5, 'ascending': 1}] %}
{% set variations_backorder_limit = [{'is_final_sale': 0, 'limit': 5, 'backorder': 1}] %}
{% set variations_backorder_limit_asc = [{'is_final_sale': 0, 'limit': 5, 'ascending': 1, 'backorder': 1}] %}
{% set variations_backorder_only = [{'limit': 5, 'backorder': 1}] %}
{% set variations_backorder_only_asc = [{'limit': 5, 'backorder': 1, 'ascending': 1}] %}
{{ generate_cte('cte_max_brw_variants', 'SELLING_PRICE desc', 'MAX_BRW_VARIANTS', variations_common) }},
{{ generate_cte('cte_min_brw_variants', 'SELLING_PRICE asc', 'MIN_BRW_VARIANTS', variations_common_asc) }},
{{ generate_cte('cte_max_price_variants', 'SELLING_PRICE desc', 'MAX_PRICE_VARIANTS', variations_with_fs) }},
{{ generate_cte('cte_min_price_variants', 'SELLING_PRICE asc', 'MIN_PRICE_VARIANTS', variations_with_fs_asc) }},
{{ generate_cte('cte_max_fs_price_variants', 'SIZE_ID asc', 'MAX_FS_PRICE_VARIANTS', variations_fs_limit) }},
{{ generate_cte('cte_min_fs_price_variants', 'SIZE_ID asc', 'MIN_FS_PRICE_VARIANTS', variations_fs_limit_asc) }},
{{ generate_cte('cte_backorder_max_variants_brw', 'SIZE_ID asc', 'BACKORDER_MAX_VARIANTS_BRW', variations_backorder_limit) }},
{{ generate_cte('cte_backorder_min_variants_brw', 'SIZE_ID asc', 'BACKORDER_MIN_VARIANTS_BRW', variations_backorder_limit_asc) }},
{{ generate_cte('cte_backorder_max_variants', 'SIZE_ID asc', 'BACKORDER_MAX_VARIANTS', variations_backorder_only) }},
{{ generate_cte('cte_backorder_min_variants', 'SIZE_ID asc', 'BACKORDER_MIN_VARIANTS', variations_backorder_only_asc) }},
{{ generate_cte('cte_min_brw_only_variants', 'SELLING_PRICE asc', 'MIN_BRW_ONLY_VARIANTS', variations_common_asc|selectattr('clearance_indicator', 'equalto', 'B')) }},
{{ generate_cte('cte_max_brw_only_variants', 'SELLING_PRICE desc', 'MAX_BRW_ONLY_VARIANTS', variations_common|selectattr('clearance_indicator', 'equalto', 'B')) }},
{{ generate_cte('cte_min_clr_only_variants', 'SELLING_PRICE asc', 'MIN_CLR_ONLY_VARIANTS', variations_common_asc|selectattr('clearance_indicator', 'equalto', 'C')) }},
{{ generate_cte('cte_max_clr_only_variants', 'SELLING_PRICE desc', 'MAX_CLR_ONLY_VARIANTS', variations_common|selectattr('clearance_indicator', 'equalto', 'C')) }},
cte_max_variants as (
    select
        a.PRODUCT_ID,
        array_agg(SIZE_ID) within group (order by SIZE_ID asc) as MAX_VARIANTS
    from (
        select
            vr.PRODUCT_ID
            , vr.SIZE_ID
        from
            {{ ref('fbb_active_styles') }} as vr
            join {{ ref('int_fbb_prices') }} as p on vr.PRODUCT_ID = p.PRODUCT_ID
        where
            SELLING_PRICE = p.MAX_BRW_PRICE
            and (QUANTITY > 0)
        qualify row_number() over(partition by vr.PRODUCT_ID order by QUANTITY desc, SIZE_ID) <= 5
    ) as a
    group by
        a.PRODUCT_ID
),
cte_min_variants as (
    select
        a.PRODUCT_ID
        , array_agg(SIZE_ID) within group (order by SIZE_ID asc) as MIN_VARIANTS
    from (
        select
            vr.PRODUCT_ID
            , vr.SIZE_ID
        from
            {{ ref('fbb_active_styles') }} as vr
            join {{ ref('int_fbb_prices') }} as p on vr.PRODUCT_ID = p.PRODUCT_ID
        where
            SELLING_PRICE = p.PRICE
            and (QUANTITY > 0)
        qualify row_number() over(partition by vr.PRODUCT_ID order by QUANTITY desc, SIZE_ID) <= 5
    ) as a
    group by
        a.PRODUCT_ID
),
cte_max_discount_id as (
    select
        PRODUCT_ID
        , SIZE_ID::varchar as MAX_DISCOUNT_ID
    from
        {{ ref('fbb_active_styles') }}
    where
        QUANTITY + BACKORDER_QUANTITY > 0
    qualify row_number() over(partition by PRODUCT_ID order by (WAS_PRICE - SELLING_PRICE) desc, QUANTITY desc) = 1
),
cte_brw_ss as (
    select
        PRODUCT_ID,
        SIZE_ID
    from
        {{ ref('fbb_active_styles') }}
    where
        QUANTITY > 0
        and CLEARANCE_INDICATOR = 'B'
    qualify row_number() over(partition by PRODUCT_ID order by WAS_PRICE - SELLING_PRICE desc, QUANTITY desc, SIZE_ID asc) = 1
),
cte_clr_ss as (
    select
        PRODUCT_ID
        , SIZE_ID
    from
        {{ ref('fbb_active_styles') }}
    where
        QUANTITY > 0
        and CLEARANCE_INDICATOR = 'C'
        and IS_FINAL_SALE = 0
    qualify row_number() over(partition by PRODUCT_ID order by WAS_PRICE - SELLING_PRICE desc, QUANTITY desc, SIZE_ID asc) = 1
),
cte_fs_ss as (
    select
        PRODUCT_ID
        , SIZE_ID
    from
        {{ ref('fbb_active_styles') }}
    where
        QUANTITY > 0
        and CLEARANCE_INDICATOR = 'C'
        and IS_FINAL_SALE = 1
    qualify row_number() over(partition by PRODUCT_ID order by WAS_PRICE - SELLING_PRICE desc, QUANTITY desc, SIZE_ID asc) = 1
)
select
    ap.PRODUCT_ID
    , cte_max_discount_id.MAX_DISCOUNT_ID
    , BACKORDER_MAX_VARIANTS_BRW as BACKORDER_MAX_VARIANTS_BRW
    , BACKORDER_MIN_VARIANTS_BRW as BACKORDER_MIN_VARIANTS_BRW
    , BACKORDER_MAX_VARIANTS as BACKORDER_MAX_VARIANTS
    , BACKORDER_MIN_VARIANTS as BACKORDER_MIN_VARIANTS
    , coalesce(MAX_BRW_VARIANTS, BACKORDER_MAX_VARIANTS_BRW, MAX_VARIANTS) as MAX_BRW_VARIANTS
    , coalesce(MIN_BRW_VARIANTS, BACKORDER_MIN_VARIANTS_BRW, MIN_VARIANTS) as MIN_BRW_VARIANTS
    , coalesce(MIN_PRICE_VARIANTS, BACKORDER_MIN_VARIANTS_BRW, MIN_VARIANTS) as MIN_PRICE_VARIANTS
    , coalesce(MAX_PRICE_VARIANTS, BACKORDER_MAX_VARIANTS_BRW, MAX_VARIANTS) as MAX_PRICE_VARIANTS
    , coalesce(MIN_FS_PRICE_VARIANTS, BACKORDER_MIN_VARIANTS_BRW, MIN_VARIANTS) as MIN_FS_PRICE_VARIANTS
    , coalesce(MAX_FS_PRICE_VARIANTS, BACKORDER_MAX_VARIANTS_BRW, MAX_VARIANTS) as MAX_FS_PRICE_VARIANTS
    , coalesce(MIN_BRW_ONLY_VARIANTS, MIN_VARIANTS, BACKORDER_MIN_VARIANTS_BRW) as MIN_BRW_ONLY_VARIANTS
    , coalesce(MAX_BRW_ONLY_VARIANTS, MAX_VARIANTS, BACKORDER_MAX_VARIANTS_BRW) as MAX_BRW_ONLY_VARIANTS
    , coalesce(MIN_CLR_ONLY_VARIANTS, MIN_VARIANTS, BACKORDER_MIN_VARIANTS_BRW) as MIN_CLR_ONLY_VARIANTS
    , coalesce(MAX_CLR_ONLY_VARIANTS, MAX_VARIANTS, BACKORDER_MAX_VARIANTS_BRW) as MAX_CLR_ONLY_VARIANTS
    , brwss.SIZE_ID as BRW_SS_VARIANT_ID
    , clrss.SIZE_ID as CLR_SS_VARIANT_ID
    , fsss.SIZE_ID as FS_SS_VARIANT_ID
from 
    {{ ref('fbb_active_products') }} as ap
    left join cte_max_discount_id on ap.PRODUCT_ID = cte_max_discount_id.PRODUCT_ID
    left join cte_max_brw_variants on ap.PRODUCT_ID = cte_max_brw_variants.PRODUCT_ID
    left join cte_min_brw_variants on ap.PRODUCT_ID = cte_min_brw_variants.PRODUCT_ID
    left join cte_max_price_variants on ap.PRODUCT_ID = cte_max_price_variants.PRODUCT_ID
    left join cte_min_price_variants on ap.PRODUCT_ID = cte_min_price_variants.PRODUCT_ID
    left join cte_max_fs_price_variants on ap.PRODUCT_ID = cte_max_fs_price_variants.PRODUCT_ID
    left join cte_min_fs_price_variants on ap.PRODUCT_ID = cte_min_fs_price_variants.PRODUCT_ID
    left join cte_backorder_max_variants_brw on ap.PRODUCT_ID = cte_backorder_max_variants_brw.PRODUCT_ID
    left join cte_backorder_min_variants_brw on ap.PRODUCT_ID = cte_backorder_min_variants_brw.PRODUCT_ID
    left join cte_backorder_max_variants on ap.PRODUCT_ID = cte_backorder_max_variants.PRODUCT_ID
    left join cte_backorder_min_variants on ap.PRODUCT_ID = cte_backorder_min_variants.PRODUCT_ID
    left join cte_brw_ss as brwss on ap.PRODUCT_ID = brwss.PRODUCT_ID
    left join cte_clr_ss as clrss on ap.PRODUCT_ID = clrss.PRODUCT_ID
    left join cte_fs_ss as fsss on ap.PRODUCT_ID = fsss.PRODUCT_ID
    left join cte_min_brw_only_variants on ap.PRODUCT_ID = cte_min_brw_only_variants.PRODUCT_ID
    left join cte_max_brw_only_variants on ap.PRODUCT_ID = cte_max_brw_only_variants.PRODUCT_ID
    left join cte_min_clr_only_variants on ap.PRODUCT_ID = cte_min_clr_only_variants.PRODUCT_ID
    left join cte_max_clr_only_variants on ap.PRODUCT_ID = cte_max_clr_only_variants.PRODUCT_ID
    left join cte_max_variants as maxv on ap.PRODUCT_ID = maxv.PRODUCT_ID
    left join cte_min_variants as minv on ap.PRODUCT_ID = minv.PRODUCT_ID
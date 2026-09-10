with max_variants as (
    select
        a.PRODUCT_ID,
        array_agg(SIZE_ID) within group (order by SIZE_ID) as MAX_VARIANTS
    from (
        select
            mst.PRODUCT_ID
            , SIZE_ID
            , SELLING_PRICE
        from
            {{ ref('miles_mp_styles') }} as mst
            left join {{ ref('int_mp_prices') }} as prices on mst.PRODUCT_ID = prices.PRODUCT_ID
        where
            QUANTITY > 0
            and SELLING_PRICE = prices.MAX_BRW_PRICE
        qualify row_number() over(partition by mst.PRODUCT_ID order by SELLING_PRICE desc, SIZE_ID) <= 5
    ) as a
    group by
        a.PRODUCT_ID
),
min_variants as (
    select
        a.PRODUCT_ID,
        array_agg(SIZE_ID) within group (order by SIZE_ID) as MIN_VARIANTS
    from (
        select
            mst.PRODUCT_ID
            , SIZE_ID
            , SELLING_PRICE
        from
            {{ ref('miles_mp_styles') }} as mst
            left join {{ ref('int_mp_prices') }} as prices on mst.PRODUCT_ID = prices.PRODUCT_ID
        where
            QUANTITY > 0
            and SELLING_PRICE = prices.MIN_BRW_PRICE
        qualify row_number() over(partition by mst.PRODUCT_ID order by SELLING_PRICE, SIZE_ID) <= 5
    ) as a
    group by
        a.PRODUCT_ID
),
brw_ss as (
    select
        PRODUCT_ID
        , SIZE_ID
    from
        {{ ref('miles_mp_styles') }}
    where
        QUANTITY > 0
        and CLEARANCE_INDICATOR = 'B'
    qualify row_number() over(partition by PRODUCT_ID order by WAS_PRICE - SELLING_PRICE desc, QUANTITY desc, SIZE_ID asc) = 1
)
select
    ap.PRODUCT_ID
    , max_variants.MAX_VARIANTS as MAX_BRW_VARIANTS
    , min_variants.MIN_VARIANTS as MIN_BRW_VARIANTS
    , max_variants.MAX_VARIANTS as MAX_PRICE_VARIANTS
    , min_variants.MIN_VARIANTS as MIN_PRICE_VARIANTS
    , max_variants.MAX_VARIANTS as MAX_FS_PRICE_VARIANTS
    , min_variants.MIN_VARIANTS as MIN_FS_PRICE_VARIANTS
    , brw_ss.SIZE_ID AS BRW_SS_VARIANT_ID
    , BRW_SS_VARIANT_ID AS CLR_SS_VARIANT_ID
    , BRW_SS_VARIANT_ID AS FS_SS_VARIANT_ID
from
    {{ ref('mp_active_products') }} as ap
    left join max_variants on ap.PRODUCT_ID = max_variants.PRODUCT_ID
    left join min_variants on ap.PRODUCT_ID = min_variants.PRODUCT_ID
    left join brw_ss on ap.PRODUCT_ID = brw_ss.PRODUCT_ID

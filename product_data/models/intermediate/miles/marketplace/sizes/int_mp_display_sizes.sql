with br as (
    select distinct
        MF_DISPLAY_SIZE
        , GROUP_ID
        , array_agg(BR_DISPLAY_SIZE) within group (order by BR_DISPLAY_SIZE) as BR_DISPLAY_SIZE
    from (
        select
            br1.MF_DISPLAY_SIZE
            , br1.GROUP_ID
            , br1.BR_DISPLAY_SIZE
        from
            {{ ref('stg_land__fbb_br_size_conversions') }} as br1
        ) as br1
    group by
        MF_DISPLAY_SIZE
        , GROUP_ID
),
panties as (
    select distinct
        panty.MF_DISPLAY_SIZE
        , array_agg(panty.BR_DISPLAY_SIZE) within group (order by panty.BR_DISPLAY_SIZE) as BR_DISPLAY_SIZE
    from (
        select
            br1.MF_DISPLAY_SIZE
            , br1.BR_DISPLAY_SIZE
        from
            {{ ref('stg_land__fbb_br_size_conversions') }} as br1
        where
            br1.GROUP_ID = 4
        ) as panty
    group by
        panty.MF_DISPLAY_SIZE
),
swim as (
    select distinct
        swim1.MF_DISPLAY_SIZE
        , array_agg(swim1.BR_DISPLAY_SIZE) within group (order by swim1.BR_DISPLAY_SIZE) as BR_DISPLAY_SIZE
    from (
        select
            br2.MF_DISPLAY_SIZE
            , br2.BR_DISPLAY_SIZE
        from
            {{ ref('stg_land__fbb_br_size_conversions') }} as br2
        where
            br2.GROUP_ID = 3
        ) as swim1
    group by
        swim1.MF_DISPLAY_SIZE
)
select
    coalesce(swim.BR_DISPLAY_SIZE, panties.BR_DISPLAY_SIZE, br.BR_DISPLAY_SIZE) AS MILES_DISPLAY_SIZE
    , sz.SIZE_ID
from
    {{ ref('stg_land__mp_sizes') }} as sz
    join {{ ref('stg_land__mp_styles') }} as st ON sz.STYLE_ID = st.STYLE_ID
    join {{ ref('stg_land__mp_products') }} as pr ON st.PRODUCT_ID = pr.PRODUCT_ID
    left join {{ ref('stg_land__mp_product_attribute_values') }} as pav ON pav.PRODUCT_ID = pr.PRODUCT_ID
    left join br on
        trim(upper(sz.MF_SIZE_ID)) = upper(br.MF_DISPLAY_SIZE)
        and br.GROUP_ID = case pav.ATTRIBUTE_VALUE when 'female' then 1 else 2 end
    left join panties on
        upper(panties.MF_DISPLAY_SIZE) = trim(upper(sz.MF_SIZE_ID))
        and pr.GOOGLE_PRODUCT_CATEGORY = 'Apparel & Accessories > Clothing > Underwear & Socks > Underwear'
        and pav.ATTRIBUTE_VALUE = 'female'
    left join swim on
        upper(swim.MF_DISPLAY_SIZE) = trim(upper(sz.MF_SIZE_ID))
        and pr.GOOGLE_PRODUCT_CATEGORY = 'Apparel & Accessories > Clothing > Swimwear'
where
    pav.ATTRIBUTE_NAME = 'gender'
group by
    coalesce(swim.BR_DISPLAY_SIZE, panties.BR_DISPLAY_SIZE, br.BR_DISPLAY_SIZE)
    , sz.SIZE_ID

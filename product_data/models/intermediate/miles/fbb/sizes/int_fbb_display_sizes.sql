WITH br as (
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
        ) br1
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
        ) panty
    group by
        MF_DISPLAY_SIZE
),
swim as (
    select distinct
        swim1.MF_DISPLAY_SIZE
        , array_agg(swim1.BR_DISPLAY_SIZE) within group (order by swim1.BR_DISPLAY_SIZE) as BR_DISPLAY_SIZE
    from (
        select
            br2.MF_DISPLAY_SIZE,
            br2.BR_DISPLAY_SIZE
        from
            {{ ref('stg_land__fbb_br_size_conversions') }} br2
        where
            br2.GROUP_ID = 3
        ) swim1
    group by
        MF_DISPLAY_SIZE
),
shoes as (
    select distinct
        shoe.MF_DISPLAY_SIZE,
        array_agg(shoe.BR_DISPLAY_SIZE) within group (order by shoe.BR_DISPLAY_SIZE) as BR_DISPLAY_SIZE
    from (
        select
            br1.MF_DISPLAY_SIZE,
            br1.BR_DISPLAY_SIZE
        from
            {{ ref('stg_land__fbb_br_size_conversions') }} br1
        where
            br1.GROUP_ID = 5
        ) shoe
    group by
        MF_DISPLAY_SIZE
)
select
    coalesce(shoes.BR_DISPLAY_SIZE, swim.BR_DISPLAY_SIZE, panties.BR_DISPLAY_SIZE, br.BR_DISPLAY_SIZE) as MILES_DISPLAY_SIZE
    , sz.SIZE_ID
    , sz.MF_SIZE_ID
    , sz.DISPLAY_SIZE
    , pr.PRODUCT_ID
    , pr.MF_DEPARTMENT
    , pr.BRAND_ID
from
    {{ ref('stg_land__fbb_sizes') }} sz
    join {{ ref('stg_land__fbb_styles') }} as st on sz.STYLE_ID = st.STYLE_ID
    join {{ ref('stg_land__fbb_products') }} as pr on st.PRODUCT_ID = pr.PRODUCT_ID
    left join br on
        sz.MF_SIZE_ID = br.MF_DISPLAY_SIZE
        and br.GROUP_ID = case when pr.BRAND_ID = 11 then 2 else 1 end
    left join panties on
        panties.MF_DISPLAY_SIZE = sz.MF_SIZE_ID
        and (MF_DEPARTMENT = '14'
            or (
                (MF_TITLE ILIKE 'PANTY%' or MF_TITLE ILIKE '%PANTIE%' or MF_TITLE ILIKE 'BRIEF%')
                and BRAND_ID = '00'
            )
            or (MF_DEPARTMENT = '33' and MF_TITLE ILIKE 'BOYSHORT%')
        )
        and MF_DEPARTMENT NOT in (62,63,64,65,66,67)
    left join swim on
        swim.MF_DISPLAY_SIZE = sz.MF_SIZE_ID
        and (pr.MF_TITLE ILIKE 'SWIM%'
            or (pr.MF_DEPARTMENT in (62,63,64,65,66,67) and pr.BRAND_ID = '24')
            or (pr.MF_DEPARTMENT in (62,63,64,65,66,67) and pr.BRAND_ID = '00')
        )
        and pr.BRAND_ID != 11
    left join shoes on
        shoes.MF_DISPLAY_SIZE = sz.MF_SIZE_ID
        and MF_TITLE ILIKE 'SLIPPER%'
group by
    coalesce(shoes.BR_DISPLAY_SIZE, swim.BR_DISPLAY_SIZE, panties.BR_DISPLAY_SIZE, br.BR_DISPLAY_SIZE)
    , sz.SIZE_ID
    , sz.MF_SIZE_ID
    , sz.DISPLAY_SIZE
    , pr.PRODUCT_ID
    , pr.MF_DEPARTMENT
    , pr.BRAND_ID

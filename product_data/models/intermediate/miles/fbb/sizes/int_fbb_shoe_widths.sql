select distinct 
    sc.MF_SIZE_ID
    , sc.MF_DISPLAY_SIZE
    , b.BRAND_ID
    , coalesce(br.BR_DISPLAY_SIZE, sc.SPLIT_SIZE_2) as SHOE_WIDTH
from
    {{ ref('stg_land__fbb_sizes') }} as sz
    join {{ ref('stg_land__fbb_styles') }} as st on st.STYLE_ID = sz.STYLE_ID
    join {{ ref('stg_land__fbb_products') }} as p on p.PRODUCT_ID = st.PRODUCT_ID
    join {{ ref('stg_land__fbb_brands') }} as b on b.BRAND_ID = p.BRAND_ID
    join {{ ref('stg_land__fbb_size_conversions') }} as sc on
        sc.MF_SIZE_ID = SZ.MF_SIZE_ID
        and sc.MF_DISPLAY_SIZE = sz.DISPLAY_SIZE
    left join {{ ref('stg_land__fbb_br_size_conversions') }} as br on
        br.MF_DISPLAY_SIZE = sc.SPLIT_SIZE_2
        and br.GROUP_ID = case when b.BRAND_ID = 11 then 7 else 6 end
where
    sc.GROUP_ID = 1
qualify
    row_number() over(partition by sc.MF_SIZE_ID, sc.MF_DISPLAY_SIZE, b.BRAND_ID
order by
    coalesce(br.BR_DISPLAY_SIZE, sc.SPLIT_SIZE_2)) = 1

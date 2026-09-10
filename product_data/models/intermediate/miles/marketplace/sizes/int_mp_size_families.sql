select distinct 
    b.BRAND_CODE
    , st.STYLE_TYPE
    , st.STYLE_ID
    , case
        when b.BRAND_CODE = 'KS' and st.STYLE_TYPE in ('B', 'R') then 'Big'
        when b.BRAND_CODE = 'KS' and st.STYLE_TYPE = 'T' then 'Tall'
        when b.BRAND_CODE not in ('KS', 'BH') and st.STYLE_TYPE = 'P' then 'Petite'
        when b.BRAND_CODE not in ('KS', 'BH') and st.STYLE_TYPE = 'T' then 'Tall'
        when b.BRAND_CODE not in ('KS', 'BH') and st.STYLE_TYPE = 'R' then 'Women''s'
        else null
    end as size_family
from
    {{ ref('stg_land__mp_brands') }} as b
    left join {{ ref('stg_land__mp_products') }} as pr on b.BRAND_ID = pr.BRAND_ID
    left join {{ ref('stg_land__mp_styles') }} as st on pr.PRODUCT_ID = st.PRODUCT_ID
group by 
    b.BRAND_CODE
    , st.STYLE_TYPE
    , st.STYLE_ID

select distinct
    br.BRAND_CODE
    , st.STYLE_TYPE
    , st.STYLE_ID
    , case
        when br.BRAND_CODE = 'KS' and st.STYLE_TYPE in ('B', 'R') then 'Big'
        when br.BRAND_CODE = 'KS' and st.STYLE_TYPE = 'T' then 'Tall'
        when br.BRAND_CODE not in ('KS', 'BH') and st.STYLE_TYPE = 'P' then 'Petite'
        when br.BRAND_CODE not in ('KS', 'BH') and st.STYLE_TYPE = 'T' then 'Tall'
        when br.BRAND_CODE not in ('KS', 'BH') and st.STYLE_TYPE = 'R' then 'Women''s'
        else null
    end as size_family
from
    {{ ref('stg_land__fbb_brands') }} as br
    left join {{ ref('stg_land__fbb_products') }} as p on br.BRAND_ID = p.BRAND_ID
    left join {{ ref('stg_land__fbb_styles') }} as st on p.PRODUCT_ID = st.PRODUCT_ID
group by
    br.BRAND_CODE
    , st.STYLE_TYPE
    , st.STYLE_ID

select
    st.COLOR_ID
    , st.PRODUCT_ID
    , st.COLOR
    , si.SIZE_ID
    , case
        when cm.COLOR_GROUP_COUNT = 1 then cm.COLOR_GROUP_ARRAY[0]
        else cm.COLOR_GROUP_ARRAY
    end as COLOR_GROUP
    , csd.COLOR_SORT_ORDER
    , csd.LOWEST_COLOR_SORT as COLOR_SORT_DEFAULT_SKU
    , ohi.VARIANT_ON_HOVER_IMAGE
    , iff(st.COLOR_ID = pmi.MAIN_COLOR_ID, true, false) as DEFAULT_SKU
    , pmi.MAIN_COLOR_ID
    , iff(DEFAULT_SKU, pmi.MAIN_IMAGE_URL, null) as MAIN_IMAGE_URL
    , iff(DEFAULT_SKU, pmi.SFCC_MAIN_IMAGE_URL, null) as SFCC_MAIN_IMAGE_URL
from
    {{ ref('stg_land__fbb_styles') }} as st
    join {{ ref('stg_land__fbb_sizes') }} as si on st.STYLE_ID = si.STYLE_ID
    join {{ ref('stg_land__fbb_products') }} as pr on st.PRODUCT_ID = pr.PRODUCT_ID
    join {{ ref('stg_land__fbb_brands') }} as br on pr.BRAND_ID = br.BRAND_ID
    left join {{ ref('int_fbb_color_groups') }} as cm on st.COLOR_ID = cm.COLOR_ID
    left join {{ ref('int_fbb_color_sort_rankings') }} as csd on st.PRODUCT_ID = csd.PRODUCT_ID and st.COLOR_ID = csd.COLOR_ID
    left join {{ ref('int_cp_variant_on_hover_image') }} as ohi on to_varchar(st.COLOR_ID) = to_varchar(ohi.VARIATION_VALUE)
    left join {{ ref('int_fbb_product_main_image') }} as pmi
        on to_varchar(st.PRODUCT_ID) = pmi.SFCC_PRODUCT_ID
               and st.COLOR_ID = pmi.MAIN_COLOR_ID
               and br.BRAND_CODE = pmi.BRAND_CODE

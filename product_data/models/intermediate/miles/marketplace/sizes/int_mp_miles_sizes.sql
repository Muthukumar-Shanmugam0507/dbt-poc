select
    si.SIZE_ID
    , disp.MILES_DISPLAY_SIZE
    , si.MF_SIZE_ID
    , sf.SIZE_FAMILY
    , GROUP_ID
    , case when pr.GOOGLE_PRODUCT_CATEGORY = 'Apparel & Accessories > Shoes'
        then ss.BR_DISPLAY_SIZE
        else null
    end as SHOE_SIZE
    , case when pr.GOOGLE_PRODUCT_CATEGORY = 'Apparel & Accessories > Shoes'
        then sw.BR_DISPLAY_SIZE
        else null
    end as SHOE_WIDTH
    , to_double(sfsi.LIST_PRICE) as PRICE
    , to_double(sfsi.SALE_PRICE) as SALE_PRICE
    , case
        when sfsi.INVENTORY_QUANTITY = 0 and sfsi.BACKORDER_QUANTITY > 0 then true
        else false
    end as BACKORDER_INDICATOR
    , sfsi.CLEARANCE_INDICATOR
    , sfsi.IS_FINAL_SALE
from
    {{ ref('stg_land__mp_sizes') }} as si
    join {{ ref('stg_land__mp_inventory') }} as inv on si.SIZE_ID = inv.SIZE_ID
    join {{ ref('stg_land__fbb_sfra_sizes') }} as sfsi on si.SIZE_ID = sfsi.SIZE_ID
    join {{ ref('stg_land__mp_styles') }} as st on si.STYLE_ID = st.STYLE_ID
    join {{ ref('stg_land__fbb_sfra_products') }} as sfpr on st.PRODUCT_ID = sfpr.PRODUCT_ID
    join {{ ref('stg_land__mp_products') }} as pr on sfpr.PRODUCT_ID = pr.PRODUCT_ID
    join {{ ref('stg_land__fbb_classifications') }} as cl on sfpr.CLASSIFICATION_CATEGORY = cl.CLASSIFICATION_ID
    left join {{ ref('int_mp_display_sizes') }} as disp on si.SIZE_ID = disp.SIZE_ID
    left join {{ ref('int_mp_size_families') }} as sf on si.STYLE_ID = sf.STYLE_ID
    left join {{ ref('int_mp_shoe_sizes') }} as ss on si.MF_SIZE_ID = ss.MF_SIZE_ID and pr.GOOGLE_PRODUCT_CATEGORY = 'Apparel & Accessories > Shoes'
    left join {{ ref('int_mp_shoe_widths') }} as sw on si.MF_SIZE_ID = sw.MF_SIZE_ID and pr.GOOGLE_PRODUCT_CATEGORY = 'Apparel & Accessories > Shoes'

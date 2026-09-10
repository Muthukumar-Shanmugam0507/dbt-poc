select
    si.SIZE_ID
     , case
        when cl.GROUP_ID = 1 THEN
          case
             when ss.shoe_size is not null then array_construct(ss.shoe_size)
             when disp.MILES_DISPLAY_SIZE is not null then disp.MILES_DISPLAY_SIZE
             when si.DISPLAY_SIZE is not null then array_construct(si.DISPLAY_SIZE)
             else null
          end
        when (cl.GROUP_ID NOT IN (1,2)) and not (cl.GROUP_ID = 0 AND pr.CLASSIFICATION_ID IN (42, 44, 45) AND pr.MF_DEPARTMENT IN (17,33)) THEN
          case
             when disp.MILES_DISPLAY_SIZE is not null then disp.MILES_DISPLAY_SIZE
             when si.DISPLAY_SIZE is not null then array_construct(si.DISPLAY_SIZE)
             else null
          end
        else null
    end AS MILES_DISPLAY_SIZE
    , si.MF_SIZE_ID
    , sf.SIZE_FAMILY
    , GROUP_ID
    , case when GROUP_ID = 1 then
          ss.SHOE_SIZE
     else
          null
     end as SHOE_SIZE
    , sw.SHOE_WIDTH
    , bcs.BRA_CUP_SIZE as BRA_CUP_SIZE
    , bbs.BRA_BAND_SIZE
    , iff(
        scp.CONVERSION is not null,
        split(replace(scp.CONVERSION, '"', ''), ','),
        null
    ) as BRA_SIZE
    , case
        when sfsi.INVENTORY_QUANTITY = 0 and sfsi.BACKORDER_QUANTITY > 0 then true
        else false
    end as BACKORDER_INDICATOR
    , sfsi.CLEARANCE_INDICATOR
    , sfsi.IS_FINAL_SALE
from
    {{ ref('stg_land__fbb_sizes') }} as si
    join {{ ref('stg_land__fbb_sfra_sizes') }} as sfsi on si.SIZE_ID = sfsi.SIZE_ID
    join {{ ref('stg_land__fbb_styles') }} as st on si.STYLE_ID = st.STYLE_ID
    join {{ ref('stg_land__fbb_sfra_products') }} as sfpr on st.PRODUCT_ID = sfpr.PRODUCT_ID
    join {{ ref('stg_land__fbb_products') }} as pr on sfpr.PRODUCT_ID = pr.PRODUCT_ID
    join {{ ref('stg_land__fbb_classifications') }} as cl on sfpr.CLASSIFICATION_CATEGORY = cl.CLASSIFICATION_ID
    left join {{ ref('int_fbb_display_sizes') }} as disp on si.SIZE_ID = disp.SIZE_ID
    left join {{ ref('int_fbb_size_families') }} as sf on si.STYLE_ID = sf.STYLE_ID
    left join {{ ref('int_fbb_shoe_sizes') }} as ss on si.MF_SIZE_ID = ss.MF_SIZE_ID and si.DISPLAY_SIZE = ss.MF_DISPLAY_SIZE and cl.GROUP_ID = ss.SC_GROUP_ID
    left join {{ ref('int_fbb_shoe_widths') }} as sw on si.MF_SIZE_ID = sw.MF_SIZE_ID and si.DISPLAY_SIZE = sw.MF_DISPLAY_SIZE and pr.BRAND_ID = sw.BRAND_ID
    left join {{ ref('int_fbb_bra_cup_sizes') }} as bcs on si.MF_SIZE_ID = bcs.MF_SIZE_ID and cl.GROUP_ID = bcs.GROUP_ID_3
    left join {{ ref('int_fbb_bra_band_sizes') }} as bbs on si.MF_SIZE_ID = bbs.MF_SIZE_ID and cl.GROUP_ID = bbs.GROUP_ID_4
    left join {{ ref('stg_land__fbb_size_selector_table_cp') }} as scp on si.SIZE_ID = scp.SIZE_ID

with cte_ids as (
    select
        pr.PRODUCT_ID as SF_PRODUCT_ID
        , pr.MF_MASTER_ITEM_ID
        , st.COLOR_ID as SF_COLOR_ID
        , st.STYLE_ID as SF_STYLE_ID
        , st.MF_STYLE_ID
        , st.MF_ITEM_ID
        , sz.SIZE_ID as SF_SIZE_ID
        , inv.QUANTITY
        , inv.BACKORDER_QUANTITY
        , pc.PRICE_ID::number as SF_PRICE_ID
        , img.IMAGE_ID::number as SF_IMAGE_ID
    from
        {{ ref('stg_land__fbb_styles') }} st
        join {{ ref('stg_land__fbb_sizes') }} as sz on sz.STYLE_ID = st.STYLE_ID
        join {{ ref('stg_land__fbb_inventory') }} as inv on inv.SIZE_ID = sz.SIZE_ID
        join {{ ref('stg_land__fbb_prices') }} as pc on pc.SIZE_ID = sz.SIZE_ID
        join {{ ref('stg_land__fbb_products') }} as pr on pr.PRODUCT_ID = st.PRODUCT_ID
        join {{ ref('stg_land__fbb_color_images') }} as cim on cim.COLOR_ID = st.COLOR_ID
        join {{ ref('stg_land__fbb_images') }} as img on img.IMAGE_ID = cim.IMAGE_ID
        join {{ ref('stg_land__fbb_brands') }} as br on pr.BRAND_ID = br.BRAND_ID
    where
        st.STATUS = 1
        and sz.STATUS = 1
        and pc.STATUS = 1
        and pr.STATUS = 1
        and inv.STATUS = 1
        and cim.STATUS = 1
        and cim.IMAGE_TYPE_ID = 5
        and TITLE is not null

    union

    select
        pr.PRODUCT_ID as SF_PRODUCT_ID
        , pr.MF_MASTER_ITEM_ID
        , st.COLOR_ID as SF_COLOR_ID
        , st.STYLE_ID as SF_STYLE_ID
        , st.MF_STYLE_ID
        , st.MF_ITEM_ID
        , sz.SIZE_ID as SF_SIZE_ID
        , inv.QUANTITY
        , inv.BACKORDER_QUANTITY
        , pc.PRICE_ID::number as SF_PRICE_ID
        , img.IMAGE_ID::number as SF_IMAGE_ID
    from
        {{ ref('stg_land__mp_styles') }} as st
        join {{ ref('stg_land__mp_sizes') }} as sz on sz.STYLE_ID = st.STYLE_ID
        join {{ ref('stg_land__mp_inventory') }} as inv on inv.SIZE_ID = sz.SIZE_ID
        join {{ ref('stg_land__mp_prices') }} as pc on pc.SIZE_ID = sz.SIZE_ID
        join {{ ref('stg_land__mp_products') }} as pr on pr.PRODUCT_ID = st.PRODUCT_ID
        join {{ ref('stg_land__mp_color_images') }} as cim on cim.COLOR_ID = st.COLOR_ID
        join {{ ref('stg_land__mp_images') }} as img on img.IMAGE_ID = cim.IMAGE_ID
        join {{ ref('stg_land__mp_brands') }} as br on pr.BRAND_ID = br.BRAND_ID
        join {{ ref('stg_land__mp_vendors') }} as v on pr.VENDOR_ID = v.MF_VENDOR_ID
    where
        st.STATUS = 1
        and sz.STATUS = 1
        and pc.STATUS = 1
        and pr.STATUS = 1
        and inv.STATUS = 1
        and cim.STATUS = 1
        and cim.IMAGE_TYPE_ID = 5
        and v.STATUS = 1
        and ENABLED_PRODUCTION = 1
        and TITLE is not null
)
select
    SF_PRODUCT_ID
    , MF_MASTER_ITEM_ID
    , SF_COLOR_ID
    , SF_STYLE_ID
    , MF_STYLE_ID
    , MF_ITEM_ID
    , SF_SIZE_ID
    , QUANTITY
    , BACKORDER_QUANTITY
    , SF_PRICE_ID
    , SF_IMAGE_ID
from
    cte_ids
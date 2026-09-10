with cte_live_gift_cards as (
    select
        distinct SFCC_PRODUCT_ID
    from {{ ref('stg_land__fbb_sfra_category_products') }}
    where product_id in (select gift_card_id from stg_land__fbb_gift_cards)
)
select distinct
    gc.BRAND_ID as EFFORT
    , b.BRAND_NAME as OWNING_BRAND
    , b.BRAND_CODE
    , substring(img.IMAGE_NAME, 3, 2) as DEPARTMENT
    , b.BRAND_NAME as BRAND_LABEL
    , gc.GIFT_CARD_ID::varchar as SF_PRODUCT_ID
    , gc.MF_ITEM_ID as MF_ID
    , gst.GIFT_CARD_STYLE_ID::varchar as SF_COLOR_ID
    , array_agg(distinct gst.MF_STYLE_ID) as STYLE_IDS
    , gc.TITLE
    , gc.DESCRIPTION
    , gst.COLOR as COLOR_NAME
    , 0 as COLOR_SORT_ORDER
    , img.IMAGE_NAME
    , img.PRODUCT_URL
    , img.PRODUCT_URL as PRODUCT_COLOR_URL
    , iff(sum(gsz.STOCK_QUANTITY) > 0, true, false) as HAS_INVENTORY
    , iff(liv.SFCC_PRODUCT_ID is not null, true, false) as IS_LIVE
    , false as IS_SLICE
from
    {{ ref('stg_land__fbb_gift_cards') }} as gc
    join {{ ref('stg_land__fbb_brands') }} as b on gc.BRAND_ID = b.BRAND_ID
    join {{ ref('stg_land__fbb_gift_card_images') }} as gci on gc.GIFT_CARD_ID = gci.GIFT_CARD_ID
    join {{ ref('stg_land__fbb_gift_card_styles') }} as gst on gc.GIFT_CARD_ID = gst.GIFT_CARD_ID
    join {{ ref('stg_land__fbb_gift_card_sizes') }} as gsz on gst.GIFT_CARD_STYLE_ID = gsz.GIFT_CARD_STYLE_ID
    left join {{ ref('int_fbb_gift_card_images') }} as img on gc.GIFT_CARD_ID = img.PRODUCT_ID
    left join cte_live_gift_cards as liv on gc.GIFT_CARD_ID = liv.SFCC_PRODUCT_ID
where
    gc.STATUS = 1
    and gst.STATUS = 1
    and gsz.STATUS = 1
    and gci.STATUS = 1
    and gc.TITLE is not null
group by
    gc.BRAND_ID
    , gc.PRODUCT_TYPE_ID
    , b.BRAND_CODE
    , b.BRAND_NAME
    , gc.GIFT_CARD_ID
    , gc.MF_ITEM_ID
    , gc.TITLE
    , gc.DESCRIPTION
    , gst.MF_STYLE_ID
    , gst.COLOR
    , img.IMAGE_NAME
    , img.PRODUCT_URL
    , gst.GIFT_CARD_STYLE_ID
    , liv.SFCC_PRODUCT_ID
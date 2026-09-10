select
    gcp.GIFT_CARD_ID
    , gcp.GIFT_CARD_STYLE_ID
    , gcp.MIN_PRICE as PRICE
    , gcp.MIN_PRICE as MIN_BROWSE_PRICE
    , gcp.MIN_PRICE as MIN_BRW_PRICE
    , gcp.MAX_PRICE as MAX_BRW_PRICE
    , gcp.MIN_PRICE as BRW_ONLY_SALE_PRICE
    , gcp.MIN_PRICE as MIN_BRW_ONLY_PRICE
    , gcp.MAX_PRICE as MAX_BRW_ONLY_PRICE
    , case when
        gcp.MIN_PRICE = gcp.MAX_PRICE
        then to_varchar(gcp.MIN_PRICE)
        else to_varchar(gcp.MIN_PRICE) || ' - ' || to_varchar(gcp.MAX_PRICE)
    end as BRW_PLP_SS
    , case when
        gcp.MIN_PRICE = gcp.MAX_PRICE
        then to_varchar(gcp.MIN_PRICE)
        else to_varchar(gcp.MIN_PRICE) || ' - ' || to_varchar(gcp.MAX_PRICE)
    end as BRW_ONLY_PLP_SS
from {{ ref('int_fbb_gift_card_base_prices') }} as gcp

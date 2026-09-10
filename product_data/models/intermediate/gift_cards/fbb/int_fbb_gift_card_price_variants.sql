select
    GIFT_CARD_ID
    , GIFT_CARD_STYLE_ID
    , ({{ get_gift_card_price_variants('GIFT_CARD_STYLE_ID', 'MIN_PRICE') }}) as MIN_BRW_VARIANTS
    , ({{ get_gift_card_price_variants('GIFT_CARD_STYLE_ID', 'MAX_PRICE') }}) as MAX_BRW_VARIANTS
    , ({{ get_gift_card_price_variants('GIFT_CARD_STYLE_ID', 'MIN_PRICE') }}) as MIN_PRICE_VARIANTS
    , ({{ get_gift_card_price_variants('GIFT_CARD_STYLE_ID', 'MAX_PRICE') }}) as MAX_PRICE_VARIANTS
from
    {{ ref('int_fbb_gift_card_base_prices') }} as gcp
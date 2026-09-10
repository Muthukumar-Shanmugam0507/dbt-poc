{% macro get_gift_card_price_variants(style_id, price) %}
select
    listagg(distinct GIFT_CARD_SIZE_ID, ',') as GIFT_CARD_SIZE_IDS
from
    {{ ref('stg_land__fbb_gift_card_sizes') }} as gsz
where
    gsz.GIFT_CARD_STYLE_ID = gcp.{{ style_id }}
    and WAS_PRICE = {{ price }}
{% endmacro %}
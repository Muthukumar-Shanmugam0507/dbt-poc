select
    to_varchar(PRODUCT_ID) as PRODUCT_ID
from
    {{ ref('fbb_active_products') }}
union
select
    to_varchar(PRODUCT_ID) as PRODUCT_ID
from
    {{ ref('mp_active_products') }}
union
select
    distinct
    PRODUCT_SET_ID as PRODUCT_ID
from
    {{ ref('fbb_active_product_sets') }}
union
select
    distinct
    SPECIAL_PRODUCT_SET_ID as PRODUCT_ID
from
    {{ ref('fbb_active_special_product_sets') }}
union
select
    SLICE_ID as PRODUCT_ID
from
    {{ ref('fbb_active_slices') }}
union
select
    SLICE_ID as PRODUCT_ID
from
    {{ ref('mp_active_slices') }}
union
select
    PRODUCT_ID
from
    {{ ref('fbb_active_gift_cards') }}
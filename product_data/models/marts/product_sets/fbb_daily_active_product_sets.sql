select
    aps.PRODUCT_SET_ID
    , aps.PRODUCT_ID
    , aps.DISPLAY_NAME
    , aps.URL
    , ({{ get_product_set_main_image('aps.PRODUCT_SET_ID', 'aps.SITE_ID') }}) as THUMB_IMAGE
    , ({{ get_active_product_sets_key() }}) as HASH_KEY
from
    {{ ref('int_fbb_product_sets_partitioned') }} as aps
    join {{ref('fbb_active_products')}} as pr on aps.PRODUCT_ID = pr.PRODUCT_ID
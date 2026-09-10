with sfra_category_products as (
    select
        distinct
        sfcc_product_id
    from
        {{ ref('stg_land__fbb_sfra_category_products') }} pr
        join {{ ref('int_active_sfra_categories') }} ca on pr.category_id = ca.category_id
)
select
    pr.PRODUCT_ID
from
    {{ ref('stg_land__fbb_sfra_products') }} pr
    join sfra_category_products ca on pr.product_id = ca.sfcc_product_id
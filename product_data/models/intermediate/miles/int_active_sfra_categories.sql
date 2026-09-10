select
     c.CATEGORY_ID
    , c.ONLINE_FLAG
    , c.POSITION
    , c.DISPLAY_NAME as NAME
    , c.BRAND_ID
    , c.PARENT as PARENT_ID
    , c.HIDE_MASTER_PRODUCT_IN_SLICING
    , c.IS_RETAIN_BR_OR_CL_PRODUCT
from
    {{ ref('stg_land__fbb_sfra_categories') }} as c
where
    (
        coalesce(IS_HIDDEN, 0) = 0
        and coalesce(ONLINE_FLAG, false) = true
        and (
            (ONLINE_FROM is null and ONLINE_TO is null)
            or
            (ONLINE_FROM is null and dateadd(day, 1, current_date())::date <= ONLINE_TO)
            or
            (ONLINE_FROM < dateadd(day, 1, current_date())::date and ONLINE_TO is null)
            or
            (ONLINE_FROM < dateadd(day, 1, current_date())::date and dateadd(day, 1, current_date())::date <= ONLINE_TO)
        )
    )
    or PARENT_ID = 'root'
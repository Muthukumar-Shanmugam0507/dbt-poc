{{
    config(
        materialized='incremental'
    )
}}

with latest_land_table_updates as (
    select
        TABLE_NAME
        , date(LAST_LOAD_TIME) UPDATED_AT
        , ROW_COUNT
        , row_number() over (partition by TABLE_NAME order by LAST_LOAD_TIME desc) as RN
    from
        {{source('INFO_SCHEMA', 'VW_LOAD_HISTORY')}}
)
select
    TABLE_NAME
    , ROW_COUNT
    , UPDATED_AT
from
    latest_land_table_updates
where
    RN = 1
with cte_clean_item_owner as (
    select distinct
        DIVISION_DEPT
        , ITEM_NUMBER as MF_ID
        , trim(left(DESCRIPTION_FULL, 8)) as SUBCATEGORY
    from {{ ref('stg_prod__finance_cmn_item_owner') }}
)
, cte_clean_division_dept as (
    select distinct
        DIVISION_DEPT
        , trim(DEPT_CATEGORY) as CATEGORY
        , trim(DEPT_DESCRIPTION) as DEPARTMENT_NAME
    from {{ ref('stg_prod__finance_cmn_division_dept') }}
)
select distinct
    left(dd.DIVISION_DEPT, 2) as EFFORT
    , right(dd.DIVISION_DEPT, 2) as DEPARTMENT
    , dd.DIVISION_DEPT
    , dd.DEPARTMENT_NAME
    , dd.CATEGORY
    , io.SUBCATEGORY
    , io.MF_ID
from
    cte_clean_division_dept as dd
    left join cte_clean_item_owner as io on dd.DIVISION_DEPT = io.DIVISION_DEPT
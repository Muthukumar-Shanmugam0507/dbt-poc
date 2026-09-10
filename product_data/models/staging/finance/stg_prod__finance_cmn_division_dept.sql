select
    nullif(trim(DIVISION_DEPT), '') as DIVISION_DEPT
    , nullif(trim(DIVISION_DEPT_AUX), '') as DIVISION_DEPT_AUX
    , nullif(trim(DEPT_GROUPS), '') as DEPT_GROUPS
    , nullif(trim(DEPT_DESCRIPTION), '') as DEPT_DESCRIPTION
    , nullif(trim(DEPT_CATEGORY), '') as DEPT_CATEGORY
    , nullif(trim(PRODUCT_MGR), '') as PRODUCT_MGR
    , nullif(trim(DMM), '') as DMM
    , nullif(trim(CONTROL_BUYER), '') as CONTROL_BUYER
    , nullif(trim(INVENTORY_DIRECTOR), '') as INVENTORY_DIRECTOR
    , nullif(trim(DEPT_CATEGORY_ROLLUP), '') as DEPT_CATEGORY_ROLLUP
from
    {{ source('PROD_CATEGORIES', 'CMN_DIVISION_DEPT') }}
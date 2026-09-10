select distinct
    EFFORT
    , DEPARTMENT
    , DEPARTMENT_NAME
    , CATEGORY
from {{ ref('int_kobe_flex_fbb_departments') }}
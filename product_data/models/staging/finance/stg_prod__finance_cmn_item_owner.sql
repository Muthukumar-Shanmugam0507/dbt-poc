select
    OWNING_DIVISION
    , DEPT
    , lpad(cast(DIVISION_DEPT as varchar), 4, '0') as DIVISION_DEPT
    , lpad(cast(ITEM_NUMBER as varchar), 5, '0') as ITEM_NUMBER
    , lpad(cast(MASTER_ITEM_NUMBER as varchar), 5, '0') as MASTER_ITEM_NUMBER
    , nullif(trim(DESCRIPTION_FULL), '') as DESCRIPTION_FULL
    , nullif(trim(PRIVATE_LABEL), '') as PRIVATE_LABEL
    , nullif(trim(NATIONAL_BRAND), '') as NATIONAL_BRAND
    , nullif(trim(PERSONALIZE_SW), '') as PERSONALIZE_SW
    , nullif(trim(DROPSHIP_SW), '') as DROPSHIP_SW
    , nullif(trim(HEMMABLE_SW), '') as HEMMABLE_SW
    , nullif(trim(NATIONAL_BRAND_SW), '') as NATIONAL_BRAND_SW
    , nullif(trim(INTRO_SEASON), '') as INTRO_SEASON
    , nullif(trim(REINTRO_SEASON), '') as REINTRO_SEASON
    , INTRO_SEASON_CALC
    , REINTRO_SEASON_CALC
from
    {{ source('PROD_CATEGORIES', 'CMN_ITEM_OWNER') }}
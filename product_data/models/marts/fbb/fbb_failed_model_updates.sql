with
cte_underpopulation_table_names as (
    select * from values
        ('STYLE'), ('SIZE'), ('INVENTORY'), ('PRICE'), ('PRODUCT'),
        ('COLORIMAGE'), ('IMAGE'), ('BRAND'), ('MP_STYLE'), ('MP_SIZE'),
        ('MP_INVENTORY'), ('MP_PRICE'), ('MP_PRODUCT'), ('MP_COLORIMAGE'),
        ('MP_IMAGE'), ('MP_BRAND'), ('MP_VENDOR')
    as t(TABLE_NAME)
),
cte_staling_table_names as (
    select * from values
        ('PRODUCT'), ('BRAND'), ('COLOR'), ('STYLE'), ('SIZE'),
        ('INVENTORY'), ('PRICE'), ('PRODUCTIMAGE'), ('IMAGE'), ('COLORIMAGE'),
        ('SFRA_PRODUCT'), ('SFRA_PRODUCTURL'), ('SFRA_CATEGORY'),
        ('SFRA_CATEGORY_PRODUCT'), ('SFRA_IMAGES'), ('ATTRIBUTE'),
        ('PRODUCTATTRIBUTEVALUE'), ('OMNITURE_DATA'), ('COLORSORTORDERSKU'),
        ('SFRA_FINALPRICE'), ('SFRA_FINALPRICEPROMO'),
        ('SFRA_CATEGORY_PRODUCTSPLIT'), ('BR_SIZECONVERSION'),
        ('SIZECONVERSION'), ('CLASSIFICATION'), ('SFRA_SIZE'),
        ('SIZESELECTORTABLE_CP'), ('COLORMAPPING'), ('SFRA_IMAGEURL'),
        ('ATTRIBUTEVALUE'), ('MP_PRODUCT'), ('MP_STYLE'), ('MP_SIZE'),
        ('MP_BRAND'), ('MP_COLOR'), ('MP_INVENTORY'), ('MP_PRICE'),
        ('MP_IMAGE'), ('MP_COLORIMAGE'), ('MP_VENDOR'), ('MP_SIZECONVERSION'),
        ('MP_PRODUCTATTRIBUTEVALUE'), ('MP_PRODUCTIMAGE'),
        ('SFRA_PRODUCTSET'), ('TURNTO_PRODUCTSETREVIEWS'),
        ('SFRA_SPECIALPRODUCTSET'), ('GIFTCARD'), ('GIFTCARDIMAGE'),
        ('GIFTCARDSIZE'), ('GIFTCARDSTYLE')
    as t(TABLE_NAME)
),
cte_tables_not_in_info_schema as (
    select
        stn.TABLE_NAME
    from
        cte_staling_table_names as stn
    left join
        (select TABLE_NAME from {{ ref('fbb_info_schema') }}) as isc
    on stn.TABLE_NAME = isc.TABLE_NAME
    where isc.TABLE_NAME is null
),
cte_stale_table_names as (
    select
        stn.TABLE_NAME
    from
        (select TABLE_NAME from {{ ref('fbb_info_schema') }}) as isc
        right join cte_staling_table_names as stn
        on stn.TABLE_NAME = isc.TABLE_NAME
    where isc.TABLE_NAME is null
),
cte_stale_tables as (
    select
        isc.TABLE_NAME,
        to_decimal((isc.ROW_COUNT / isch.ROW_COUNT) * 100, 10, 2) || '%' as ROWS_COMPARISON,
        isc.UPDATED_AT
    from
        {{ ref('fbb_info_schema') }} as isc
        left join {{ ref('fbb_info_schema_history') }} as isch
        on isc.TABLE_NAME = isch.TABLE_NAME
    where
        isc.UPDATED_AT <> current_date
        and isc.TABLE_NAME in (select TABLE_NAME from cte_staling_table_names)
),
cte_underpopulated_tables as (
    select
        isc.TABLE_NAME,
        to_decimal((isc.ROW_COUNT / isch.ROW_COUNT) * 100, 10, 2) || '%' as ROWS_COMPARISON,
        isc.UPDATED_AT
    from
        {{ ref('fbb_info_schema') }} as isc
        left join {{ ref('fbb_info_schema_history') }} as isch
        on isc.TABLE_NAME = isch.TABLE_NAME
    where
        isch.ROW_COUNT > 0
        and isch.UPDATED_AT = dateadd(day, -1, isc.UPDATED_AT)
        and isc.ROW_COUNT < 0.95 * isch.ROW_COUNT
        and isc.TABLE_NAME in (select TABLE_NAME from cte_underpopulation_table_names)
),
cte_combined_underpopulated_tables as (
    select
        TABLE_NAME,
        'MISSING' as ROWS_COMPARISON,
        null as UPDATED_AT
    from
        cte_tables_not_in_info_schema
    union all
    select
        TABLE_NAME,
        ROWS_COMPARISON,
        UPDATED_AT
    from
        cte_underpopulated_tables
)
select
    coalesce(stt.TABLE_NAME, upt.TABLE_NAME) as TABLE_NAME
    , case
        when stt.TABLE_NAME is not null then 'STALE'
        when upt.TABLE_NAME is not null then 'UNDERPOPULATED'
    end as ISSUE_TYPE
    , coalesce(stt.ROWS_COMPARISON, upt.ROWS_COMPARISON) as ROWS_COMPARISON
    , coalesce(stt.UPDATED_AT, upt.UPDATED_AT) as UPDATED_AT
from
    cte_stale_tables as stt
    full outer join cte_combined_underpopulated_tables as upt
    on stt.TABLE_NAME = upt.TABLE_NAME
order by TABLE_NAME
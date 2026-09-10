select
    to_number(pa.PRODUCT_ID) as PRODUCT_ID
    , case when left(pa.PRODUCT_ID::varchar, 1) = '6' then 'MP' else BRAND_CODE end as BRAND_CODE
    , ATTRIBUTE_NAME
    , ATTRIBUTE_VALUE
    , pa.CREATED_AT
    , pa.CREATED_AT as UPDATED_AT
    , 'HUMAN' as ANNOTATED_BY
from
    {{ ref('stg_pdm__product_attributes') }} as pa
    left join {{ ref('stg_land__fbb_products') }} as pr on pr.PRODUCT_ID = pa.PRODUCT_ID
    left join {{ ref('stg_land__fbb_brands') }} as br on br.BRAND_ID = pr.BRAND_ID
where
    pa.PRODUCT_ID in (
        select
            PRODUCT_ID
        from
            {{ ref('stg_pdm__product_attributes') }}
        group by
            PRODUCT_ID
        having
            count(*) >= 5
    )
    {% if is_incremental() %}
    and (pa.PRODUCT_ID, pa.ATTRIBUTE_NAME, pa.ATTRIBUTE_VALUE)
        not in (
            select
                PRODUCT_ID
                , ATTRIBUTE_NAME
                , ATTRIBUTE_VALUE
            from
                {{this}}
        )
    {% endif %}
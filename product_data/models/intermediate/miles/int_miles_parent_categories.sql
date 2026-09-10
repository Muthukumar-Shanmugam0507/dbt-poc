-- pack ancestors (excluding the leaf itself) into an ordered JSON array
select
    LEAF_CATEGORY_ID
    , array_agg(
        object_construct(
            'id', ANCESTOR_CATEGORY_ID,
            'name', ANCESTOR_NAME
        )
    ) within group (order by LEVEL_FROM_LEAF desc) as PARENT_CATEGORIES
from
    {{ ref('int_category_tree') }}
where
    LEVEL_FROM_LEAF >= 0
group by
    LEAF_CATEGORY_ID
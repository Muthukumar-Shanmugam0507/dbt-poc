with cte_mf_item_ids as (
    select
        st.PRODUCT_ID as SF_PRODUCT_ID
        , array_agg(distinct st.MF_ITEM_ID) within group (order by st.MF_ITEM_ID asc) as MF_ITEM_IDS
    from
        {{ ref('stg_land__fbb_styles') }} as st
    where
        st.STATUS = 1
    group by
        st.PRODUCT_ID
)
select
    prs.OWNING_BRAND_ID
    , prs.OWNING_BRAND
    , prs.BRAND_CODE
    , prs.DEPARTMENT
    , prs.PCM_BRAND
    , prs.SF_PRODUCT_ID
    , prs.MF_PRODUCT_ID
    , mid.MF_ITEM_IDS
    , prs.SF_COLOR_ID
    , array_agg(distinct prs.MF_COLOR_ID) within group (order by prs.MF_COLOR_ID asc) as MF_COLOR_ID
    , prs.TITLE
    , prs.MF_TITLE
    , prs.DESCRIPTION
    , prs.COLOR
    , prs.COLOR_SORT_ORDER
    , prs.PRODUCT_URL
    , prs.PRODUCT_COLOR_URL
    , iff(sum(szs.QUANTITY) + sum(szs.BACKORDER_QUANTITY) > 0, true, false) as HAS_INVENTORY
    , prs.IS_LIVE
    , iff(slc.COLOR_ID is null, false, true) as IS_SLICE
    , prs.IS_DROPSHIP
from
    {{ ref('int_kobe_product_to_style') }} as prs
    join {{ ref('int_kobe_fbb_size_to_style') }} as szs on prs.STYLE_ID = szs.STYLE_ID
    left join {{ ref('stg_land__fbb_sfra_category_product_splits') }} as slc on prs.SF_PRODUCT_ID = slc.PRODUCT_ID and prs.SF_COLOR_ID = slc.COLOR_ID
    join cte_mf_item_ids as mid on prs.SF_PRODUCT_ID = mid.SF_PRODUCT_ID
group by
    prs.OWNING_BRAND_ID
    , prs.OWNING_BRAND
    , prs.BRAND_CODE
    , prs.DEPARTMENT
    , prs.PCM_BRAND
    , prs.SF_PRODUCT_ID
    , prs.MF_PRODUCT_ID
    , mid.MF_ITEM_IDS
    , prs.SF_COLOR_ID
    , slc.COLOR_ID
    , prs.TITLE
    , prs.MF_TITLE
    , prs.DESCRIPTION
    , prs.COLOR
    , prs.COLOR_SORT_ORDER
    , prs.PRODUCT_URL
    , prs.PRODUCT_COLOR_URL
    , prs.IS_LIVE
    , prs.IS_DROPSHIP
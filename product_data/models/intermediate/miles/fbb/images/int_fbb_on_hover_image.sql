with main_colors as (
    select distinct
        PRODUCT_ID
        , MAIN_IMAGE_URL
        , SFCC_MAIN_IMAGE_URL
        , MAIN_COLOR_ID
        , THUMB_IMAGE
    from
        {{ ref('miles_fbb_styles') }}
    qualify ROW_NUMBER() over(partition by PRODUCT_ID order by PRODUCT_ID, MAIN_COLOR_ID) = 1
),
mb as (
    select
        pim.PRODUCT_ID
        , imu.URL
        , sfi.IMAGE_PATH
    from
        {{ ref('stg_land__fbb_images') }} as im
        inner join {{ ref('stg_land__fbb_product_images') }} as pim on im.IMAGE_ID = pim.IMAGE_ID
        inner join {{ ref('stg_land__fbb_sfra_images') }} as sfi on im.IMAGE_NAME = sfi.IMAGE_NAME
        left join {{ ref('stg_land__fbb_sfra_image_urls') }} as imu on pim.PRODUCT_ID = imu.PRODUCT_ID and imu.TYPE = 'on-hover' and imu.VARIATION_VALUE is null
    where
        pim.IMAGE_TYPE_ID = 4
        and pim.STATUS = 1
    qualify row_number() over(partition by pim.PRODUCT_ID order by imu.IMAGE_NAME, im.SEQUENCE) = 1
),
ma as (
    select
        pim1.PRODUCT_ID
        , imu1.URL
        , sfi1.IMAGE_PATH
    from
        {{ ref('stg_land__fbb_images') }} as im1
        inner join {{ ref('stg_land__fbb_sfra_images') }} as sfi1 on im1.IMAGE_NAME = sfi1.IMAGE_NAME
        inner join {{ ref('stg_land__fbb_product_images') }} as pim1 on im1.IMAGE_ID = pim1.IMAGE_ID
        left join {{ ref('stg_land__fbb_sfra_image_urls') }} as imu1 on pim1.PRODUCT_ID = imu1.PRODUCT_ID and imu1.TYPE = 'alternate' and imu1.VARIATION_VALUE is null
    where
        pim1.IMAGE_TYPE_ID = 3
        and pim1.STATUS = 1
    qualify row_number() over(partition by pim1.PRODUCT_ID order by imu1.IMAGE_NAME, im1.SEQUENCE) = 1
),
pc as (
    select
        pc.SIZE_ID
        , pc.SELLING_PRICE
    from
        {{ ref('stg_land__fbb_prices') }} as pc
    where
        pc.STATUS = 1
    qualify row_number() over(partition by pc.SIZE_ID order by pc.CREATED_AT DESC) = 1
),
coloralt as (
    select
        st.PRODUCT_ID
        , st.COLOR_ID
        , sz.SIZE_ID
    from
        {{ ref('stg_land__fbb_sizes') }} as sz
        inner join pc on sz.SIZE_ID = pc.SIZE_ID
        inner join {{ ref('stg_land__fbb_inventory') }} as inv on sz.SIZE_ID = inv.SIZE_ID
        inner join {{ ref('stg_land__fbb_styles') }} as st on st.STYLE_ID = sz.STYLE_ID
    where
        sz.STATUS = 1
        and st.STATUS = 1
    qualify row_number() over(partition by st.PRODUCT_ID order by pc.SELLING_PRICE DESC, inv.QUANTITY DESC) = 1
)
select
    p.PRODUCT_ID
    , p.BRAND_ID
    , ( {{ get_style_thumb_image('coloralt.SIZE_ID', 'b.BRAND_CODE') }} ) as ALT_THUMB_IMAGE
    , coalesce(mb.URL, mb.IMAGE_PATH, ma.URL, ma.IMAGE_PATH, ALT_THUMB_IMAGE) as ON_HOVER_IMAGE
    , replace(ON_HOVER_IMAGE, substring(ON_HOVER_IMAGE, 0, regexp_instr(ON_HOVER_IMAGE, '/on/') - 1), b.IMAGE_DOMAIN) as ON_HOVER_IMAGE_URL
from
    {{ ref('stg_land__fbb_products') }} as p
    join {{ ref('stg_land__fbb_brands') }} as b on b.BRAND_ID = p.BRAND_ID
    left join mb on mb.PRODUCT_ID = p.PRODUCT_ID
    left join ma on ma.PRODUCT_ID = p.PRODUCT_ID
    left join main_colors as ast on p.PRODUCT_ID = ast.PRODUCT_ID
    left join {{ ref('int_fbb_fs_main_image') }} as fsimg on p.PRODUCT_ID = fsimg.PRODUCT_ID and b.BRAND_ID = fsimg.BRAND_ID
    left join coloralt on coloralt.PRODUCT_ID = p.PRODUCT_ID and coloralt.COLOR_ID != coalesce(ast.MAIN_COLOR_ID, fsimg.COLOR_ID)
qualify row_number() over(partition by p.PRODUCT_ID ORDER BY p.PRODUCT_ID) = 1

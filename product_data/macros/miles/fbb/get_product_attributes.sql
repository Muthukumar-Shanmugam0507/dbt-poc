{% macro get_product_attributes() %}
{% set attribute_names = [
    'bottom_fit', 'care', 'closure', 'fabric_/_material', 'features', 'item_type', 'length',
    'neckline', 'occasion', 'sleeve_length', 'style', 'coat_weight', 'sock_height',
    'bra_lining', 'shape', 'swim_coverage', 'shoe_height', 'fabric', 'sets', 'thread_count',
    'sheet_type', 'pillow_type', 'sleep_position', 'lighting_type', 'lighting_color', 'width',
    'towel_type', 'cuup_product_type', 'pocket_type', 'product_thickness', 'comfort_level',
    'weight', 'light_count', 'height', 'beauty_features', 'season', 'strap_type', 'shoe_width',
    'support_level', 'multi_packs', 'bra_support_level', 'shorts_inseam', 'material',
    'construction', 'light_filtration', 'theme', 'voltage', 'capacity', 'heel_height', 'cuup_silhouette',
    'cuup_sheerness', 'fill_material', 'wreath_size', 'application', 'eyewear_shape'
] %}

select
    PRODUCT_ID,
    {% for attribute in attribute_names %}
        iff(
            array_size(array_agg(case when BLOOMREACH_ATTRIBUTE_NAME = '{{ attribute }}' then av.ATTRIBUTE_VALUE end)) > 0
            , array_agg(case when BLOOMREACH_ATTRIBUTE_NAME = '{{ attribute }}' then av.ATTRIBUTE_VALUE end)
            , null
        )
            as {{ attribute.replace('fabric_/_material', 'fabric_material')
            .replace('height', 'height_').replace('_height_', '_height')
            .replace('capacity', 'capacity_') | replace('-', '_') | upper }},
    {% endfor %}
from
    {{ ref('stg_land__fbb_product_attribute_values') }} as pa
    left join {{ ref('stg_land__fbb_attributes') }} as att on pa.ATTRIBUTE_ID = att.ATTRIBUTE_ID
    left join {{ ref('stg_land__fbb_attribute_values') }} as av on pa.ATTRIBUTE_VALUE_ID = av.ATTRIBUTE_VALUE_ID
group by
    PRODUCT_ID
{% endmacro %}

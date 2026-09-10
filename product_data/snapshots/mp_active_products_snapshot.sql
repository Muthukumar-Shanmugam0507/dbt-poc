{% snapshot snapshot_mp_active_products %}

{{
    config(
        target_database='DS_PROJECTS',
        unique_key='HASH_KEY',
        strategy='check',
        check_cols=['HASH_KEY'],
        invalidate_hard_deletes=True
    )
}}

select * from {{ ref('mp_daily_active_products') }}

{% endsnapshot %}

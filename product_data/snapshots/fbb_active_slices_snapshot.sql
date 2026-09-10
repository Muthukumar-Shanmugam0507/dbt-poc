{% snapshot snapshot_fbb_active_slices %}
{{
    config(
        target_database='DS_PROJECTS',
        unique_key='HASH_KEY',
        strategy='check',
        check_cols=['HASH_KEY'],
        invalidate_hard_deletes=True
    )
}}
select * from {{ ref('fbb_daily_active_slices') }}
{% endsnapshot %}
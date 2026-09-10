{% snapshot snapshot_mp_kobe_variants %}
{{
    config(
        target_database='DS_PROJECTS',
        unique_key='HASH_KEY',
        strategy='check',
        check_cols=['HASH_KEY'],
        invalidate_hard_deletes=True
    )
}}
select * from {{ ref('kobe_mp_daily_variants') }}
{% endsnapshot %}
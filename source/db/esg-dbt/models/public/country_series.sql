
{{
    config(materialized='persistent_table'
        ,retain_previous_version_flg=false)
}}

CREATE TABLE {{ database }}.{{ schema }}.country_series (
    country_code varchar(10),
    series_code varchar(100),
    last_update_at timestamp
)
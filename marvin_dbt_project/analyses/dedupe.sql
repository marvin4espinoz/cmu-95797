-- deduplicate rows using QUALIFY and row_number() by using the mart__dim_events table

with events as (

    select
        *
    from
        {{ ref('mart__dim_events') }}

)

select * from events 
QUALIFY row_number() over (PARTITION by event_id order by insert_timestamp desc) = 1
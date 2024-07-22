-- mart__fact_all_bike_trips.sql
-- 

with source as (
    select * from {{ ref('stg__bike_data') }}
),

renamed as (

    select
        bike_trip_id
        , started_at_ts
        , ended_at_ts
        , datediff('second', started_at_ts, ended_at_ts) as duration_sec
        , datediff('minute', started_at_ts, ended_at_ts) as duration_min
        , start_station_id
        , end_station_id

    from
        source

)

select * from renamed
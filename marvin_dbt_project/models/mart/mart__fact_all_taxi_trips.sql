-- create fact_all_taxi_trips data model / table
-- TAXI trips, referenced tables are: 

with fhv as (

    select
        'fhv' as type
        , pickup_datetime as pickup_datetime
        , dropoff_datetime as dropoff_datetime
        , datediff('minute', pickup_datetime, dropoff_datetime) as duration_min
        , datediff('second', pickup_datetime, dropoff_datetime) as duration_sec
        , taxi_zone_began as pickup_location_id
        , taxi_zone_ended as dropoff_location_id
    from
        {{ ref('stg__fhv_tripdata') }}

),

fhvhv as (

    select
        'fhvhv' as type
        , pickup_datetime as pickup_datetime
        , dropoff_datetime as dropoff_datetime
        , datediff('minute', pickup_datetime, dropoff_datetime) as duration_min
        , datediff('second', pickup_datetime, dropoff_datetime) as duration_sec
        , taxi_zone_location_began as pickup_location_id
        , taxi_zone_location_ended as dropoff_location_id

    from
        {{ ref('stg__fhvhv_tripdata') }}

),

green as (

    select
        'green' as type
        , lpep_pickup_datetime as pickup_datetime
        , lpep_dropoff_datetime as dropoff_datetime
        , datediff('minute', lpep_pickup_datetime, lpep_dropoff_datetime) as duration_min
        , datediff('second', lpep_pickup_datetime, lpep_dropoff_datetime) as duration_sec
        , taxi_zone_location_pickup as pickup_location_id
        , taxi_zone_location_dropoff as dropoff_location_id

    from
        {{ ref('stg__green_tripdata') }}

),

yellow as (

    select
        'green' as type
        , tpep_pickup_datetime as pickup_datetime
        , tpep_dropoff_datetime as dropoff_datetime
        , datediff('minute', tpep_pickup_datetime, tpep_dropoff_datetime) as duration_min
        , datediff('second', tpep_pickup_datetime, tpep_dropoff_datetime) as duration_sec
        , taxi_zone_location_pickup as pickup_location_id
        , taxi_zone_location_dropoff as dropoff_location_id

    from
        {{ ref('stg__yellow_tripdata') }}

),

taxi_all_stacked as (

    select * from fhv 
    UNION ALL 
    select * from fhvhv 
    UNION ALL 
    select * from yellow
    UNION ALL 
    select * from green

)

select
    type
    , pickup_datetime
    , dropoff_datetime
    , duration_min
    , duration_sec
    , pickup_location_id
    , dropoff_location_id
from 
    taxi_all_stacked
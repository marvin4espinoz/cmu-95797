-- create fact_all_trips_daily data model / table
-- TAXI trips, referenced tables are: 

with fhv as (

    select
        'fhv' as type
        , pickup_datetime as pickup_datetime
        , dropoff_datetime as dropoff_datetime
        , datediff('minute', pickup_datetime, dropoff_datetime) as duration_min
        , datediff('second', pickup_datetime, dropoff_datetime) as duration_sec

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

    from
        {{ ref('stg__yellow_tripdata') }}

),

bike as (

    select
        'bike' as type
        , started_at_ts as pickup_datetime
        , ended_at_ts as dropoff_datetime
        , datediff('minute', started_at_ts, ended_at_ts) as duration_min
        , datediff('second', started_at_ts, ended_at_ts) as duration_sec
    from
        {{ ref('stg__bike_data') }}

),

all_stacked as (

    select * from fhv 
    UNION ALL 
    select * from fhvhv 
    UNION ALL 
    select * from yellow
    UNION ALL 
    select * from green
    UNION ALL 
    select * from bike

)

select
    type
    , pickup_datetime as started_at_ts
    , dropoff_datetime as ended_at_ts
    , duration_min
    , duration_sec
from 
    all_stacked
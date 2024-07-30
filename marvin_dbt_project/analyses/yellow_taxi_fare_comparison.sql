with yellow as (

    select
        'green' as type
        , tpep_pickup_datetime as pickup_datetime
        , tpep_dropoff_datetime as dropoff_datetime
        , datediff('minute', tpep_pickup_datetime, tpep_dropoff_datetime) as duration_min
        , datediff('second', tpep_pickup_datetime, tpep_dropoff_datetime) as duration_sec
        , taxi_zone_location_pickup as pickup_location_id
        , taxi_zone_location_dropoff as dropoff_location_id
        , trip_fare_amount as fare_amount
        , yellow_trip_id

    from
        {{ ref('stg__yellow_tripdata') }}
),

boroughs as (

    select 
        *
    from 
        {{ ref('mart__dim_locations') }}

)

select
    y.yellow_trip_id,
    y.fare_amount,
    b.zone,
    b.borough,
    avg(y.fare_amount) OVER () AS overall_avg_fare,
    avg(y.fare_amount) OVER (PARTITION BY b.zone) AS zone_avg_fare,
    avg(y.fare_amount) OVER (PARTITION BY b.borough) AS borough_avg_fare
from
    yellow y left join boroughs b ON y.pickup_location_id = b.locationID



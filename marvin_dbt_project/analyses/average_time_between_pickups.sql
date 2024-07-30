-- find average time between pickups by zone

with taxi_trips as (

    select
        *
    from 
        {{ ref('mart__fact_all_taxi_trips') }}
    
),

boroughs as (

    select 
        *
    from 
        {{ ref('mart__dim_locations') }}

),

pickups as (

    select
        b.Zone as Zone_in_Borough
        , t.pickup_datetime as initial_pickup
        , LAG(t.pickup_datetime, 1) OVER (PARTITION BY b.Zone ORDER BY t.pickup_datetime) as lag1_pickup
    from
        taxi_trips t left join boroughs b ON t.pickup_location_id = b.locationID
),

differences as (

    select
        Zone_in_Borough as Zone
        , datediff('second', lag1_pickup, initial_pickup) as time_diff_btwn_pickups_in_zone
    from
        pickups
    where
        datediff('second', lag1_pickup, initial_pickup) is not null
)

select
    Zone
    , round(avg(time_diff_btwn_pickups_in_zone)/60,2) as avg_pickup_to_pickup_time_mins
from
    differences
where
    time_diff_btwn_pickups_in_zone is not null
group by
    Zone
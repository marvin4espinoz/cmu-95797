--taxi_trips_no_valid_pickup_location_id.sql
-- finds taxi trips which don't have a pickup_location_id in the locations table.  Return the count() of total such trips

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

)

select
    t.*
from
    taxi_trips t left join boroughs b ON t.pickup_location_id = b.locationID
where
    b.locationID is null
-- group by and having
-- find all zones where there are less than 100,000 trips

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
    b.zone
    , count(*)
from 
    taxi_trips t left join boroughs b ON t.pickup_location_id = b.locationID
group by
    b.zone
having 
    count(*) < 100000
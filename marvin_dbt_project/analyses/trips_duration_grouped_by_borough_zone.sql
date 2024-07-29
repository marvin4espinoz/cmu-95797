-- calculate the number of (taxi) trips and average duration by borough and zone

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
    b.Borough as Borough
    , b.Zone as Zone_in_Borough
    , count(*) as number_of_taxi_trips
    , avg(t.duration_min) as avg_duration_min
    , avg(t.duration_sec) as avg_duration_sec
from
    taxi_trips t left join boroughs b ON t.pickup_location_id = b.locationID
                                      and t.pickup_location_id is not null
                                      and b.Borough is not null 
group by 
    b.Borough
    , b.Zone
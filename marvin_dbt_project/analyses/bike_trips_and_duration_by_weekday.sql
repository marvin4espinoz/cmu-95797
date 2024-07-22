-- bike_trips_and_duration_by_weekday.sql
-- want to answer: count & total time of bikes trips by weekday
-- count of bikes per day + total time of bikes per day

with source as (

    select
        *
    from 
        {{ ref('mart__fact_all_bike_trips') }}
)

select
    DAYNAME(started_at_ts) as weekday
    , count(*) as num_bikes
    , round(sum(duration_sec)/3600,2) as total_time_bikes_hrs
from source
group by weekday
having weekday NOT IN ('Saturday', 'Sunday')
-- inter_borough_taxi_trips_by_weekday.sql

-- inter_borough_taxi_trips_by_weekday.sql

with taxi_trips as (
    select *
    from "cmu_95797_data_warehousing_project"."main"."mart__fact_all_taxi_trips"
),

locations as (
    select *
    from "cmu_95797_data_warehousing_project"."main"."mart__dim_locations"
),

trip_data as (
    select
        DAYNAME(t.pickup_datetime) as weekday,
        l.Borough as pickup_borough,
        l2.Borough as dropoff_borough,
        case when l.Borough != l2.Borough then 1 else 0 end as diff_borough
    from
        taxi_trips t 
            LEFT JOIN locations l ON t.pickup_location_id = l.LocationID
            LEFT JOIN locations l2 ON t.dropoff_location_id = l2.LocationID
)

select
    weekday,
    count(*) as total_trips,
    sum(diff_borough) as total_inter_borough_trips,
    round(sum(diff_borough) * 100.0 / nullif(count(*), 0), 3) as inter_borough_percent
from
    trip_data
where weekday not in ('Saturday', 'Sunday')
group by weekday
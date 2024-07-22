-- taxi_trips_ending_at_airport.sql
-- total number of trips ending in service_zones 'Airports' or 'EWR'

with taxi_trips as (

    select
        *
    from 
        {{ ref('mart__fact_all_taxi_trips') }}
),

locations as (

    select
        *
    from
        {{ ref('mart__dim_locations')}}
)

SELECT 
	count(*) as total_num_trips_ewr_arprt
FROM
	taxi_trips t LEFT JOIN locations l
		ON t.dropoff_location_id = l.LocationID 
WHERE 
	upper(l.service_zone) LIKE '%EWR%' 
	OR upper(l.ZONE) LIKE '%AIRPORT%'
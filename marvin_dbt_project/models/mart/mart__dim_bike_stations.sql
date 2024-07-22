-- bike stations dimension table: primary key = station_id
-- each row is a station and includes "largely unchanging" information about that station (characteristics)

with source as (
    select * from {{ ref('stg__bike_data') }}
),

start_stations as (

    select
        DISTINCT
        --'Start Station' as station_type
        start_station_id as station_id
        , start_station_name as station_name
        , start_station_latitude as station_latitude
        , start_station_longitude as station_longitude
    from
        source

),

end_stations as (

    select
        DISTINCT
        --'End Station' as station_type
        end_station_id as station_id
        , end_station_name as station_name
        , end_station_latitude as station_latitude
        , end_station_longitude as station_longitude
    from
        source

)

select * from start_stations
UNION
select * from end_stations

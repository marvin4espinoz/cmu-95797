with source as (
    select * from {{ source('main', 'bike_data') }}
),
renamed as (
    select
        distinct
        tripduration::int as tripduration_sec,
        case 
            when tripduration::int <= 2845 then tripduration::int 
            else null 
         end as tripduration_sec_clean,
        {{ cast_to_timestamp('starttime') }} as start_time,
        {{ cast_to_timestamp('stoptime') }} as stoptime,
        TRIM("start station id") AS start_station_id,
        UPPER(TRIM("start station name")) AS start_station_name,
        {{ round_coordinates('"start station latitude"', 4) }} AS start_station_latitude,
        {{ round_coordinates('"start station longitude"', 4) }} AS start_station_longitude,
        {{ format_location('start_station_latitude', 'start_station_longitude') }} AS start_location,
        TRIM("end station id") AS end_station_id,
        UPPER(TRIM("end station name")) AS end_station_name,
        {{ round_coordinates('"end station latitude"', 4) }} AS end_station_latitude,
        {{ round_coordinates('"end station longitude"', 4) }} AS end_station_longitude,
        {{ format_location('end_station_latitude', 'end_station_longitude') }} AS end_location,
        TRIM(bikeid) as bikeid,
        UPPER(TRIM(usertype)) as usertype,
        "birth year" AS birth_year,
        {{ calculate_age('"birth year"') }} AS age,
        UPPER({{ clean_gender('gender') }}) AS gender_clean,
        filename
    from source
),
final as (
    select
        COALESCE(concat(start_station_id,'-',end_station_id,'-', start_time, '-', stoptime, '-', bikeid),'Unknown') as bike_trip_id, --primary key
        --COALESCE(tripduration_sec, -1) AS tripduration_sec,
        COALESCE(tripduration_sec_clean, -1) AS tripduration_sec_clean,
        COALESCE(start_time, '1900-01-01 00:00:00'::timestamp) AS start_time,
        COALESCE(stoptime, '1900-01-01 00:00:00'::timestamp) AS stoptime,
        COALESCE(start_station_id, 'Unknown') AS start_station_id,
        COALESCE(start_station_name, 'Unknown') AS start_station_name,
        --COALESCE(start_station_latitude, -999.9999) AS start_station_latitude,
        --COALESCE(start_station_longitude, -999.9999) AS start_station_longitude,
        COALESCE(start_location, 'Unknown') AS start_location,
        COALESCE(end_station_id, 'Unknown') AS end_station_id,
        COALESCE(end_station_name, 'Unknown') AS end_station_name,
        --COALESCE(end_station_latitude, -999.9999) AS end_station_latitude,
        --COALESCE(end_station_longitude, -999.9999) AS end_station_longitude,
        COALESCE(end_location, 'Unknown') AS end_location,
        COALESCE(bikeid, 'Unknown') AS bikeid,
        COALESCE(usertype, 'Unknown') AS usertype,
        COALESCE(birth_year, 'Unknown') AS birth_year,        
        COALESCE(age, -1) AS age,
        COALESCE(gender_clean, 'Unknown') AS gender_clean,
        COALESCE(filename, 'Unknown') AS filename
    from renamed
)

select * from final


with source as (
    select * from {{ source('main', 'bike_data') }}
),
renamed as (
    select
        distinct
        --timestamp information and trip duration
        tripduration::int as tripduration_sec,
        case when tripduration::int <= 2845 then tripduration::int else null end as tripduration_sec_clean,
        {{ cast_to_timestamp('starttime') }} as start_time,
        {{ cast_to_timestamp('stoptime') }} as stop_time,
        
        --columns with spaces between them that have "duplicate" version with underscores
        --start station columns
        {{ trup('"start station id"') }} AS "start station id",
        {{ trup('"start station name"') }} AS "start station name",
        {{ round_coordinates('"start station latitude"', 4) }} AS "start station latitude",
        {{ round_coordinates('"start station longitude"', 4) }} AS "start station longitude",
        {{ format_location('"start station latitude"', '"start station longitude"') }} AS start_location_lat_long,

        --end station columns
        {{ trup('"end station id"') }} AS "end station id",
        {{ trup('"end station name"') }} AS "end station name",
        {{ round_coordinates('"end station latitude"', 4) }} AS "end station latitude",
        {{ round_coordinates('"end station longitude"', 4) }} AS "end station longitude",
        {{ format_location('"end station latitude"', '"end station longitude"') }} AS end_location_lat_long,

        --columns without spaces between them that have "duplicate" version without underscores
        -- timestamps - p2 - second set of columns
        {{ cast_to_timestamp('started_at') }} as started_at,--timestamp 2
        {{ cast_to_timestamp('ended_at') }} as ended_at,--timestamp 2

        --start station columns - p2 - second set
        {{ trup('start_station_id') }} as start_station_id,
        {{ trup('start_station_name') }} as start_station_name,
        {{ round_coordinates('start_lat',4) }} as start_lat_round,
        {{ round_coordinates('start_lng', 4) }} as start_long_round,
        {{ format_location('start_lat_round', 'start_long_round') }} AS start_location_lat_long_2,

        --end station columns - p2 - second set
        {{ trup('end_station_id') }} as end_station_id,
        {{ trup('end_station_name') }} as end_station_name,
        {{ round_coordinates('end_lat',4) }} as end_lat_round,
        {{ round_coordinates('end_lng', 4) }} as end_long_round,
        {{ format_location('end_lat_round', 'end_long_round') }} AS end_location_lat_long_2,

        --other identification columns
        {{ trup('bikeid') }} as bikeid,
        {{ trup('usertype') }} as usertype,
        "birth year" AS birth_year,
        {{ calculate_age('"birth year"') }} AS age,
        {{ clean_gender('gender') }} AS gender_clean,
        filename
    from source
),
final as (
    select

        --timestamp information
        coalesce(coalesce(start_time, started_at), NULL) as started_at_ts,
        coalesce(coalesce(stop_time, ended_at), NULL) as ended_at_ts,
        CASE 
            when coalesce(coalesce(tripduration_sec_clean, datediff('second', started_at_ts, ended_at_ts)), NULL) > 2845 THEN null
            when coalesce(coalesce(tripduration_sec_clean, datediff('second', started_at_ts, ended_at_ts)), NULL) < 0 THEN null
            else coalesce(coalesce(tripduration_sec_clean, datediff('second', started_at_ts, ended_at_ts)), NULL)::int
        END as tripduration_sec_final,

        --start station information
        coalesce(coalesce("start station id", start_station_id), NULL) as start_station_id,  
        coalesce(coalesce("start station name", start_station_name), NULL) as start_station_name,
        coalesce(coalesce("start station latitude", start_lat_round), NULL) as start_station_latitude,
        coalesce(coalesce("start station longitude", start_long_round), NULL) as start_station_longitude,
        coalesce(start_location_lat_long, start_location_lat_long_2) as start_location_lat_long_final,

        --end station information
        coalesce(coalesce("end station id", end_station_id), NULL) as end_station_id,  
        coalesce(coalesce("end station name", end_station_name), NULL) as end_station_name,
        coalesce(coalesce("end station latitude", end_lat_round), NULL) as end_station_latitude,
        coalesce(coalesce("end station longitude", end_long_round), NULL) as end_station_longitude,
        coalesce(end_location_lat_long, end_location_lat_long_2) as end_location_lat_long_final,
        
        --other identification columns
        COALESCE(bikeid, NULL) AS bikeid,
        COALESCE(usertype, NULL) AS usertype,
        COALESCE(birth_year, NULL) AS birth_year,        
        COALESCE(age, NULL) AS age,
        COALESCE(gender_clean, NULL) AS gender_clean,
        -- primary key
        COALESCE(concat(start_station_id,'-',end_station_id,'-', started_at_ts, '-', ended_at_ts, '-', bikeid), NULL) as bike_trip_id,

        --filename
        COALESCE(filename, NULL) AS filename


    from renamed
)


select * from final
with source as (
    select * from {{ source('main', 'central_park_weather') }}
),


renamed as (
    select
        distinct
        TRIM(station) as station_id,
        TRIM(name) as station_name,
        date::date as date_of_observation,  --note to self: can't trim dates
        TRIM(concat(station, '-', date::date)) as station_date_id,
        awnd::double as average_wind_speed,
        prcp::double as precipitation_amount,
        snow::double as snowfall_amount,
        snwd::double as snow_depth,
        tmax::int as temperature_max,
        tmin::int as temperature_min,
        TRIM(filename) as filename
    from source
),


cleaned as (
    select
        COALESCE(station_date_id, NULL) as station_date_id, -- primary key
        COALESCE(station_id, NULL) AS station_id,
        COALESCE(station_name, NULL) AS station_name,
        COALESCE(date_of_observation, NULL) AS date_of_observation,
        COALESCE(average_wind_speed, NULL) AS average_wind_speed,
        COALESCE(precipitation_amount,NULL) AS precipitation_amount,
        COALESCE(snowfall_amount, NULL) AS snowfall_amount,
        COALESCE(snow_depth, NULL) AS snow_depth,
        COALESCE(temperature_max, NULL) AS temperature_max,
        COALESCE(temperature_min, NULL) AS temperature_min,
        COALESCE(filename, NULL) AS filename
    from renamed
)


select * from cleaned

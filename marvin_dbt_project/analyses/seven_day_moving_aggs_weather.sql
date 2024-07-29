-- seven day moving aggregations from stg__central_park_weather data model
-- aggregations: min, max, avg, sum
-- values: precipitation_amount, snowfall_amount


with weather as (

    select
        *
    from
        {{ ref('stg__central_park_weather') }}

)

select 
    station_date_id,
    station_id,
    station_name,
    date_of_observation,
    precipitation_amount,
    snowfall_amount,
    min(precipitation_amount) over seven_days as min_7day_precipitation,
    max(precipitation_amount) over seven_days as max_7day_precipitation,
    avg(precipitation_amount) over seven_days as avg_7day_precipitation,
    sum(precipitation_amount) over seven_days as sum_7day_precipitation,
    min(snowfall_amount) over seven_days as min_7day_snowfall,
    max(snowfall_amount) over seven_days as max_7day_snowfall,
    avg(snowfall_amount) over seven_days as avg_7day_snowfall,
    sum(snowfall_amount) over seven_days as sum_7day_snowfall

from 
    weather
window seven_days as (
    order by date_of_observation ASC
    RANGE BETWEEN INTERVAL 3 DAYS PRECEDING AND 
                  INTERVAL 3 DAYS FOLLOWING)
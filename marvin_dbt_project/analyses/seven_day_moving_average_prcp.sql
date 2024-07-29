-- 7 day moving average of precipitation for every day in central_park_weather

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
    avg(precipitation_amount) OVER (ORDER BY date_of_observation
                                    RANGE BETWEEN INTERVAL '3' DAY PRECEDING AND INTERVAL '3' DAY FOLLOWING
        ) AS avg_7day_precipitation
from 
    weather
order by
    date_of_observation
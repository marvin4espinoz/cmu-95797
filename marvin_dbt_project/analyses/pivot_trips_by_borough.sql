-- turn mart__fact_trips_by_borough.sql and transpose it using pivot macro

select
  {{ dbt_utils.pivot(
      'Borough',
      dbt_utils.get_column_values(ref('mart__fact_trips_by_borough'), 'Borough'),
      agg = 'sum',
      then_value = 'number_of_taxi_trips'
  ) }}
from {{ ref('mart__fact_trips_by_borough') }}
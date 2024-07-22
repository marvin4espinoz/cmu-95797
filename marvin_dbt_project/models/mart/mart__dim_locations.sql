-- taxi zone locations lookup table: primary key = 
-- each row is a location with its corresponding characteristics (largely unchanging descriptive data)

select 
    {{ dbt_utils.star(ref('taxi_lookup')) }}
from 
    {{ ref('taxi_lookup') }}
.echo on

-- General Step: Print out table names and schemas.  Use: SHOW and DESCRIBE


-- 1.0 - Dump TABLE NAMES
SHOW TABLES;


-- 2.0 - Dump TABLE SCHEMAS
.schema bike_data
describe "bike_data";


.schema central_park_weather
describe central_park_weather;


.schema fhv_bases
describe fhv_bases;


.schema fhv_tripdata
describe fhv_tripdata;


.schema fhvhv_tripdata
describe fhvhv_tripdata;


.schema green_tripdata
describe green_tripdata;


.schema yellow_tripdata
describe yellow_tripdata;


.schema taxi_zones_shp
describe taxi_zones_shp;

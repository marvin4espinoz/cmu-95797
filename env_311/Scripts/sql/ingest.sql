-- General Step:
--     Load data into DuckDB database from local machine where awscli downloaded into




-- 1.0 - LOAD DATA into DuckDB - CSV files first


-- 1.a - LOAD: Table 1 - fhv_bases - .CSV
-- create table
CREATE TABLE fhv_bases AS
    SELECT *
    FROM "C:\Users\MarvinEspinoza-Leiva\github-repo-folder\cmu-95797\data\data\fhv_bases.csv";
-- view raw table
SELECT * FROM fhv_bases;


-- 1.b - LOAD: Table 2 - central_park_weather - .CSV
CREATE TABLE central_park_weather AS
    SELECT *
    FROM "C:\Users\MarvinEspinoza-Leiva\github-repo-folder\cmu-95797\data\data\central_park_weather.csv";
-- view raw table
SELECT * FROM central_park_weather;




-- 2.0 - LOAD DATA into DuckDB - PARQUET files second


-- 2.a - LOAD: Table 3 - taxi\fhv_tripdata
CREATE TABLE fhv_tripdata AS
    SELECT *
    FROM read_parquet('C:\Users\MarvinEspinoza-Leiva\github-repo-folder\cmu-95797\data\data\taxi\fhv_tripdata.parquet');
-- view raw table
SELECT * FROM fhv_tripdata;


-- #2.b - LOAD: Table 4 - taxi\fhvhv_tripdata
CREATE TABLE fhvhv_tripdata AS
    SELECT *
    FROM read_parquet('C:\Users\MarvinEspinoza-Leiva\github-repo-folder\cmu-95797\data\data\taxi\fhvhv_tripdata.parquet');
-- view raw table
SELECT * FROM fhvhv_tripdata;


-- #2.c - LOAD: Table 5 - taxi\green_tripdata
CREATE TABLE green_tripdata AS
    SELECT *
    FROM read_parquet('C:\Users\MarvinEspinoza-Leiva\github-repo-folder\cmu-95797\data\data\taxi\green_tripdata.parquet');
SELECT * FROM green_tripdata;


-- #2.d - LOAD: Table 6 - taxi\yellow_tripdata
CREATE TABLE yellow_tripdata AS
    SELECT *
    FROM read_parquet('C:\Users\MarvinEspinoza-Leiva\github-repo-folder\cmu-95797\data\data\taxi\yellow_tripdata.parquet');
SELECT * FROM yellow_tripdata;




-- #3.0 - LOAD DATA into DuckDB - taxi_zones\ - geospatial files third: .dbf, .pri, .sbn, .sbx, .shp, .xml, .shx


-- 3.0.a - install and load spatial extension for duckdb
INSTALL spatial;
LOAD spatial;


-- 3.1 - LOAD: Table 7 - taxi_zones\taxi_zones.shp
CREATE TABLE taxi_zones_shp AS
    SELECT *
    FROM 'C:\Users\MarvinEspinoza-Leiva\github-repo-folder\cmu-95797\data\data\taxi_zones\taxi_zones.shp';


-- check to see if the geospatial scan is what i wanted:
SELECT * FROM taxi_zones_shp;




-- 4.0 LOAD DATA into DuckDB - citibike-tripdata.csv.gz
CREATE TABLE bike_data AS
    SELECT *
    FROM read_csv_auto('C:\Users\MarvinEspinoza-Leiva\github-repo-folder\cmu-95797\data\data\citibike-tripdata.csv.gz');


-- check
SELECT * FROM bike_data;



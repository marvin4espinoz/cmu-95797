-- staging data model (table) for: fhv_bases in duckdb database: cmu_95797_data_warehousing_project.db
-- general "data dictionary" can be found here: https://github.com/toddwschneider/nyc-taxi-data/blob/master/README.md 
-- actual data dictionary: https://data.cityofnewyork.us/Transportation/FHV-Base-Aggregate-Report/2v9c-2k7f/about_data 

with source as (
    select * from {{ source('main', 'fhv_bases') }}
),

renamed as (
    select
        distinct
        base_number,
        base_name as company_name,
        dba as company_service_name,
        dba_category as ride_share_service_used,
        filename
    from source
),

cleaned as (
    select
        COALESCE(base_number, 'Unknown') as base_number, -- primary key
        COALESCE(company_name, 'Unknown') as company_name,
        COALESCE(company_service_name, 'Unknown') as company_service_name,
        COALESCE(ride_share_service_used, 'Unknown') as ride_share_service_used,
        COALESCE(filename, 'Unknown') as filename
    from renamed
)

select * from cleaned
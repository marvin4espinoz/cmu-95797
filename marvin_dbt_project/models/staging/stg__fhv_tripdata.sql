-- staging data model for fhv_tripdata in duckdb database: cmu_95797_data_warehousing_project.db
-- data dictionary: https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_fhv.pdf

with source as (
    select * from {{ source('main', 'fhv_tripdata') }}
),

renamed as (
    select
        distinct
        trim(upper(dispatching_base_num)) as dispatch_base_license_num,
        {{ cast_to_timestamp('pickup_datetime') }} AS pickup_datetime,
        {{ cast_to_timestamp('dropOff_datetime') }} AS dropoff_datetime,
        TRY_CAST(pickup_datetime AS DATE) AS pickup_date_only,
        TRY_CAST(dropOff_datetime AS DATE) as dropoff_date_only,
        PUlocationID::VARCHAR as taxi_zone_began,
        DOlocationID::VARCHAR as taxi_zone_ended,
        trim(upper(affiliated_base_number)) as affiliated_base_number,    --removed SRC_flag because all values were null
        filename
    from source
),

cleaned as (
    select
        COALESCE(concat(dispatch_base_license_num, '-', pickup_datetime, '-', dropoff_datetime, '-', taxi_zone_began, '-', taxi_zone_ended),NULL) as fhv_trip_id,
        COALESCE(dispatch_base_license_num, NULL) as dispatch_base_license_num,
        COALESCE(pickup_datetime, NULL) as pickup_datetime,
        COALESCE(dropoff_datetime, NULL) as dropoff_datetime,
        COALESCE(pickup_date_only, NULL) as pickup_date_only,
        COALESCE(dropoff_date_only, NULL) as dropoff_date_only,
        COALESCE(taxi_zone_began, NULL) as taxi_zone_began,
        COALESCE(taxi_zone_ended, NULL) as taxi_zone_ended,
        COALESCE(filename, NULL) as filename
    from renamed
)

select * from cleaned
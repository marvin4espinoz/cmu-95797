-- staging data model for green_tripdata in duckdb database: cmu_95797_data_warehousing_project.db
-- data dictionary: https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_green.pdf 

with source as (
    select * from {{ source('main', 'green_tripdata') }}
),

renamed as (
    select
        distinct
        VendorID as lpep_provider_id,
        {{ cast_to_timestamp('lpep_pickup_datetime') }} as lpep_pickup_datetime,
        {{ cast_to_timestamp('lpep_dropoff_datetime') }} as lpep_dropoff_datetime,
        TRY_CAST(lpep_pickup_datetime AS DATE) AS lpep_pickup_date_only,
        TRY_CAST(lpep_dropoff_datetime AS DATE) as lpep_dropoff_date_only,
        passenger_count as passenger_count_trip,
        trip_distance as trip_miles,
        PULocationID as taxi_zone_location_pickup,
        DOLocationID as taxi_zone_location_dropoff,
        RatecodeID as trip_code_id,
        store_and_fwd_flag,
        payment_type as trip_payment_type,
        fare_amount as trip_fare_amount,
        extra as extra_charges_trip,
        mta_tax as mta_tax_amount,
        improvement_surcharge,
        tip_amount as tip_amount_nocash,
        tolls_amount,
        total_amount as total_amount_lessCash,
        trip_type,
        filename
    from source
),

cleaned as (
    select
        COALESCE(concat(lpep_provider_id, '-', lpep_pickup_datetime, '-', lpep_dropoff_datetime, '-', taxi_zone_location_pickup, '-', taxi_zone_location_dropoff), 'Unknown') as green_trip_id,
        COALESCE(lpep_provider_id, -1) as lpep_provider_id,
        COALESCE(lpep_pickup_datetime, '1900-01-01 00:00:00'::timestamp) as lpep_pickup_datetime,
        COALESCE(lpep_dropoff_datetime, '1900-01-01 00:00:00'::timestamp) as lpep_dropoff_datetime,
        COALESCE(lpep_pickup_date_only, '1900-01-01'::date) as lpep_pickup_date_only,
        COALESCE(lpep_dropoff_date_only, '1900-01-01'::date) as lpep_dropoff_date_only,
        COALESCE(passenger_count_trip, -1) as passenger_count_trip,
        COALESCE(trip_miles, -1) as trip_miles,
        COALESCE(taxi_zone_location_pickup, -1) as taxi_zone_location_pickup,
        COALESCE(taxi_zone_location_dropoff, -1) as taxi_zone_location_dropoff,
        COALESCE(trip_code_id, -1) as trip_code_id,
        COALESCE(store_and_fwd_flag, 'Unknown') as store_and_fwd_flag,
        COALESCE(trip_payment_type, -1) as trip_payment_type,
        COALESCE(trip_fare_amount, -1) as trip_fare_amount,
        COALESCE(extra_charges_trip, -1) as extra_charges_trip,
        COALESCE(mta_tax_amount, -1) as mta_tax_amount,
        COALESCE(improvement_surcharge, -1) as improvement_surcharge,
        COALESCE(tip_amount_nocash, -1) as tip_amount_nocash,
        COALESCE(tolls_amount, -1) as tolls_amount,
        COALESCE(total_amount_lessCash, -1) as total_amount_lessCash,
        COALESCE(trip_type, -1) as trip_type,
        COALESCE(filename, 'Unknown') as filename
    from renamed
)

select * from cleaned
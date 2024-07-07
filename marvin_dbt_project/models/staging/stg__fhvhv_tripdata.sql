-- staging data model for fhvhv_tripdata in duckdb database: cmu_95797_data_warehousing_project.db
-- data dictionary: https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_hvfhs.pdf 

with source as (
    select * from {{ source('main', 'fhvhv_tripdata') }}
),

renamed as (
    select
        distinct
        hvfhs_license_num as taxi_license_number,
        dispatching_base_num as dispatch_base_license_number,
        {{ cast_to_timestamp('pickup_datetime') }} AS pickup_datetime,
        {{ cast_to_timestamp('dropOff_datetime') }} AS dropoff_datetime,
        TRY_CAST(pickup_datetime AS DATE) AS pickup_date_only,
        TRY_CAST(dropOff_datetime AS DATE) as dropoff_date_only,
        PUlocationID as taxi_zone_location_began,
        DOlocationID as taxi_zone_location_ended,
        originating_base_num as original_base_of_trip_request,
        {{ cast_to_timestamp('request_datetime') }} as datetime_of_trip_request,
        {{ cast_to_timestamp('on_scene_datetime') }} as datetime_of_driver_arrival,
        trip_miles,
        trip_time as trip_time_seconds,
        base_passenger_fare as trip_fare_amount,
        tolls as tolls_paid_amount,
        bcf as bcf_collected_amount,
        sales_tax as sales_tax_amount,
        congestion_surcharge as congestion_surcharge_amount,
        airport_fee as airport_fee_amount,
        tips as tips_amount,
        driver_pay as driver_pay_amount,
        shared_request_flag,
        shared_match_flag,
        access_a_ride_flag,
        wav_request_flag,
        wav_match_flag,
        filename
    from source
),

cleaned as (
    select
        COALESCE(concat(dispatch_base_license_number, '-', taxi_license_number, '-', pickup_datetime, '-', dropoff_datetime, '-', taxi_zone_location_began, '-', taxi_zone_location_ended), 'Unknown') as fhvhv_trip_id,
        COALESCE(taxi_license_number, 'Unknown') as taxi_license_number,
        COALESCE(dispatch_base_license_number, 'Unknown') as dispatch_base_license_number,
        COALESCE(pickup_datetime, '1900-01-01 00:00:00'::timestamp) as pickup_datetime,
        COALESCE(dropoff_datetime, '1900-01-01 00:00:00'::timestamp) as dropoff_datetime,
        COALESCE(pickup_date_only, '1900-01-01'::date) as pickup_date_only,
        COALESCE(dropoff_date_only, '1900-01-01'::date) as dropoff_date_only,
        COALESCE(taxi_zone_location_began, -1) as taxi_zone_location_began,
        COALESCE(taxi_zone_location_ended, -1) as taxi_zone_location_ended,
        COALESCE(original_base_of_trip_request, 'Unknown') as original_base_of_trip_request,
        COALESCE(datetime_of_trip_request, '1900-01-01 00:00:00'::timestamp) as datetime_of_trip_request,
        COALESCE(datetime_of_driver_arrival, '1900-01-01 00:00:00'::timestamp) as datetime_of_driver_arrival,
        COALESCE(trip_miles, -1) as trip_miles,
        COALESCE(trip_time_seconds, -1) as trip_time_seconds,
        COALESCE(trip_fare_amount, -1) as trip_fare_amount,
        COALESCE(tolls_paid_amount, -1) as tolls_paid_amount,
        COALESCE(bcf_collected_amount, -1) as bcf_collected_amount,
        COALESCE(sales_tax_amount, -1) as sales_tax_amount,
        COALESCE(congestion_surcharge_amount, -1) as congestion_surcharge_amount,
        COALESCE(airport_fee_amount, -1) as airport_fee_amount,
        COALESCE(tips_amount, -1) as tips_amount,
        COALESCE(driver_pay_amount, -1) as driver_pay_amount,
        COALESCE(shared_request_flag, 'Unknown') as shared_request_flag,
        COALESCE(shared_match_flag, 'Unknown') as shared_match_flag,
        COALESCE(access_a_ride_flag, 'Unknown') as access_a_ride_flag,
        COALESCE(wav_request_flag, 'Unknown') as wav_request_flag,
        COALESCE(wav_match_flag, 'Unknown') as wav_match_flag,
        COALESCE(filename, 'Unknown') as filename
    from renamed
)

select * from cleaned
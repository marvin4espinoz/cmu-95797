-- staging data model for green_tripdata in duckdb database: cmu_95797_data_warehousing_project.db
-- data dictionary: https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf 

with source as (
    select * from {{ source('main', 'yellow_tripdata') }}
),

renamed as (
    select
        distinct
        VendorID as tpep_provider_id,
        {{ cast_to_timestamp('tpep_pickup_datetime') }} as tpep_pickup_datetime,
        {{ cast_to_timestamp('tpep_dropoff_datetime') }} as tpep_dropoff_datetime,
        TRY_CAST(tpep_pickup_datetime AS DATE) AS tpep_pickup_date_only,
        TRY_CAST(tpep_dropoff_datetime AS DATE) as tpep_dropoff_date_only,
        passenger_count as passenger_count_trip,
        trip_distance as trip_miles,
        PULocationID as taxi_zone_location_pickup,
        DOLocationID as taxi_zone_location_dropoff,
        RatecodeID as trip_code_id,
        {{flag_to_bool("store_and_fwd_flag")}} as store_and_fwd_flag,
        payment_type as trip_payment_type,
        fare_amount as trip_fare_amount,
        extra as extra_charges_trip,
        mta_tax as mta_tax_amount,
        improvement_surcharge,
        tip_amount as tip_amount_nocash,
        tolls_amount,
        total_amount as total_amount_lessCash,
        congestion_surcharge as congestion_surcharge_amount,
        airport_fee as airport_fee_amount,
        filename
    from source
        WHERE tpep_pickup_datetime < TIMESTAMP '2022-12-31' -- drop rows in the future
          AND trip_distance >= 0 -- drop negative trip_distance
),

cleaned as (
    select
        COALESCE(concat(tpep_provider_id, '-', tpep_pickup_datetime, '-', tpep_dropoff_datetime, '-', taxi_zone_location_pickup, '-', taxi_zone_location_dropoff), NULL) as yellow_trip_id,
        COALESCE(tpep_provider_id, NULL) as tpep_provider_id,
        COALESCE(tpep_pickup_datetime, NULL) as tpep_pickup_datetime,
        COALESCE(tpep_dropoff_datetime, NULL) as tpep_dropoff_datetime,
        COALESCE(tpep_pickup_date_only, NULL) as tpep_pickup_date_only,
        COALESCE(tpep_dropoff_date_only, NULL) as tpep_dropoff_date_only,
        COALESCE(passenger_count_trip, NULL) as passenger_count_trip,
        COALESCE(trip_miles, NULL) as trip_miles,
        COALESCE(taxi_zone_location_pickup, NULL) as taxi_zone_location_pickup,
        COALESCE(taxi_zone_location_dropoff, NULL) as taxi_zone_location_dropoff,
        COALESCE(trip_code_id, NULL) as trip_code_id,
        COALESCE(store_and_fwd_flag, NULL) as store_and_fwd_flag,
        COALESCE(trip_payment_type, NULL) as trip_payment_type,
        COALESCE(trip_fare_amount, NULL) as trip_fare_amount,
        COALESCE(extra_charges_trip, NULL) as extra_charges_trip,
        COALESCE(mta_tax_amount, NULL) as mta_tax_amount,
        COALESCE(improvement_surcharge, NULL) as improvement_surcharge,
        COALESCE(tip_amount_nocash, NULL) as tip_amount_nocash,
        COALESCE(tolls_amount, NULL) as tolls_amount,
        COALESCE(total_amount_lessCash, NULL) as total_amount_lessCash,
        COALESCE(congestion_surcharge_amount, NULL) as congestion_surcharge_amount,
        COALESCE(airport_fee_amount, NULL) as airport_fee_amount,
        COALESCE(filename, NULL) as filename
    from renamed
)

select * from cleaned
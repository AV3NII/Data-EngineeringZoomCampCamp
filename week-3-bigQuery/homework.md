
# Prepare data
-   created docker container with a mage instance to load it to the gcs bucket
-   run container and pipe

-   Created external table in bigquery from gcs bucket

{
    CREATE TABLE `zoomcamp-dataengineering.ny_taxi.dataInternal` AS
    SELECT *
    FROM `zoomcamp-dataengineering.ny_taxi.data`;
}
    

-> this creates a bigquery table form the external table


# Question 1
{
    Select count(1) from `ny_taxi.dataInternal`
}
    
- 840402

# Question 2

{
    SELECT COUNT(distinct(PULocationID)) From `ny_taxi.dataInternal`
}

- External Table:   Bytes processed   6.41 MB initially
- Internal (Materialized Table): Bytes processed   6.41 MB initially

-> 0 MB for the External Table and 6.41MB for the Materialized Table

# Question 3

{
    select count(*) 
    from `ny_taxi.dataInternal`
    where fare_amount = 0
}

-> 1622



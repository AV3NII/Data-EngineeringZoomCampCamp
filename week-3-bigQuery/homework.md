
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

# Question 4

{
    CREATE TABLE `zoomcamp-dataengineering.ny_taxi.optimizedTable`
    PARTITION BY DATE(lpep_pickup_datetime)
    CLUSTER BY PUlocationID AS
    SELECT
      * 
    FROM
    `zoomcamp-dataengineering.ny_taxi.dataInternal`;

}
- Partition by lpep_pickup_datetime Cluster on PUlocationID


# Question 5
{
    SELECT DISTINCT PULocationID
    FROM `zoomcamp-dataengineering.ny_taxi.optimizedTable`
    WHERE lpep_pickup_datetime >= '2022-06-01 00:00:00'
    AND lpep_pickup_datetime <= '2022-06-30 23:59:59';
}
- 12.82 mb Materialized Table
- 1.12 mb partitioned Table

    - 12.82 MB for non-partitioned table and 1.12 MB for the partitioned table

# Question 6
- GCP Bucket

# Question 7
- True

# Question 8
{
    select count(*) from `ny_taxi.dataInternal`
}

- 0 bytes (Was executed already by bigquery. it is precached)

- BigQuery hat processes in the background that speed things up. for example it uses meta data about the table to calculate the result of the Query insted of retriefing all data and then counting it.


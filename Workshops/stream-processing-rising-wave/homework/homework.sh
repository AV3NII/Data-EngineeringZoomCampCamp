
cd ../course

source commands.sh
# First, reset the cluster:
clean-cluster
# Start a new cluster
start-cluster
# wait for cluster to start
sleep 5
# Seed historical data instead of real-time data
seed-kafka
# Recreate trip data table
psql -f risingwave-sql/table/trip_data.sql
# Wait for a while for the trip_data table to be populated.
sleep 5
# Check that you have 100K records in the trip_data table
# You may rerun it if the count is not 100K
psql -c "SELECT COUNT(*) FROM trip_data"
psql -c "SELECT * FROM trip_data limit 1"
psql -c "SELECT * FROM taxi_zone limit 1"
# SETUP DONE

# Question 0

psql -c "DROP MATERIALIZED VIEW IF EXISTS zone_of_latest_dropoff;
CREATE MATERIALIZED VIEW zone_of_latest_dropoff AS \
    SELECT \
        MAX(td.tpep_dropoff_datetime) AS latest_dropoff_time, \
        tz.Zone AS dropOffZone \
    FROM \
        trip_data td \
    JOIN \
        taxi_zone tz ON td.dolocationid = tz.location_id \
    GROUP BY \
        td.dolocationid, tz.Zone \
    ORDER BY \
        latest_dropoff_time DESC \
    LIMIT 1" # returnes the zone of the most recent dropoff

# Answer: 
# latest_dropoff_time |  dropoffzone   
#---------------------+----------------
# 2022-01-03 17:24:54 | Midtown Center
#(1 row)


# Question 1

    #create table with avg min and max for trip_duration 
psql -c "DROP MATERIALIZED VIEW IF EXISTS taxi_zone_trip_duration_stats;
CREATE MATERIALIZED VIEW taxi_zone_trip_duration_stats AS \
    SELECT \
        pickup.zone AS pickup_zone, \
        dropoff.zone AS dropoff_zone, \
        AVG(EXTRACT(EPOCH FROM (td.tpep_dropoff_datetime - td.tpep_pickup_datetime)) / 60) AS avg_trip_time_minutes, \
        MIN(EXTRACT(EPOCH FROM (td.tpep_dropoff_datetime - td.tpep_pickup_datetime)) / 60) AS min_trip_time_minutes, \
        MAX(EXTRACT(EPOCH FROM (td.tpep_dropoff_datetime - td.tpep_pickup_datetime)) / 60) AS max_trip_time_minutes \
    FROM \
        trip_data td \
    JOIN \
        taxi_zone pickup ON td.PULocationID = pickup.location_id \
    JOIN \
        taxi_zone dropoff ON td.DOLocationID = dropoff.location_id \
    GROUP BY \
        pickup.zone, dropoff.zone;"

    # query the highest avrage duration
psql -c "SELECT pickup_zone, dropoff_zone, avg_trip_time_minutes \
    FROM taxi_zone_trip_duration_stats \
    ORDER BY avg_trip_time_minutes DESC \
    LIMIT 1;" 

# Answer: 
#  pickup_zone   | dropoff_zone | avg_trip_time_minutes 
#----------------+--------------+-----------------------
# Yorkville East | Steinway     |           1439.550000
#(1 row)


# Question 2

    #create table with new specification
psql -c "DROP MATERIALIZED VIEW IF EXISTS taxi_zone_trip_duration_stats_with_count;
CREATE MATERIALIZED VIEW taxi_zone_trip_duration_stats_with_count AS \
    SELECT \
        pickup.zone AS pickup_zone, \
        dropoff.zone AS dropoff_zone, \
        COUNT(*) AS number_of_trips, \
        AVG(EXTRACT(EPOCH FROM (td.tpep_dropoff_datetime - td.tpep_pickup_datetime)) / 60) AS avg_trip_time_minutes, \
        MIN(EXTRACT(EPOCH FROM (td.tpep_dropoff_datetime - td.tpep_pickup_datetime)) / 60) AS min_trip_time_minutes, \
        MAX(EXTRACT(EPOCH FROM (td.tpep_dropoff_datetime - td.tpep_pickup_datetime)) / 60) AS max_trip_time_minutes \
    FROM \
        trip_data td \
    JOIN \
        taxi_zone pickup ON td.PULocationID = pickup.location_id \
    JOIN \
        taxi_zone dropoff ON td.DOLocationID = dropoff.location_id \
    GROUP BY \
        pickup.zone, dropoff.zone;"

    # get longest trip -> return count of trips between these locations
psql -c "SELECT pickup_zone, dropoff_zone, avg_trip_time_minutes, number_of_trips \
    FROM taxi_zone_trip_duration_stats_with_count \
    ORDER BY avg_trip_time_minutes DESC \
    LIMIT 1;"

# Answer:
#  pickup_zone   | dropoff_zone | avg_trip_time_minutes | number_of_trips 
#----------------+--------------+-----------------------+-----------------
# Yorkville East | Steinway     |           1439.550000 |               1
#(1 row)


# Question 3 

#get latest pickup
psql -c "SELECT MAX(tpep_pickup_datetime) AS latest_pickup_time FROM trip_data;"

# based on this get the most recent 17 hours. return the pickup locations with highest trip count
psql -c "WITH LatestPickup AS ( \
        SELECT MAX(tpep_pickup_datetime) AS latest_pickup_time FROM trip_data \
    ), \
    FilteredTrips AS ( \
        SELECT \
            td.PULocationID, \
            COUNT(*) AS pickup_count \
        FROM \
            trip_data td, LatestPickup lp \
        WHERE \
            td.tpep_pickup_datetime BETWEEN (lp.latest_pickup_time - INTERVAL '17 HOURS') AND lp.latest_pickup_time \
        GROUP BY \
            td.PULocationID \
    ) \
    SELECT \
        tz.zone, \
        ft.pickup_count \
    FROM \
        FilteredTrips ft \
    JOIN \
        taxi_zone tz ON ft.PULocationID = tz.location_id \
    ORDER BY \
        ft.pickup_count DESC \
    LIMIT 3;"

#Answer: 
#        zone         | pickup_count 
#---------------------+--------------
# LaGuardia Airport   |           19
# Lincoln Square East |           17
# JFK Airport         |           17
#(3 rows)
#!/bin/bash

python ingest_data.py --user=root --password=root --host=pgdatabase --port=5432 --db=ny_taxi --table_name=green_tripdata --url=https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz

python ingest_data1.py --user=root --password=root --host=pgdatabase --port=5432 --db=ny_taxi --table_name=taxi_zonedata --url=https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv
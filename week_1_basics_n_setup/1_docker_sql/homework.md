# Homework 1

### Question 1

- '--rm' => Automatically remove the container when it exits

### Question 2

- '0.42.0'

### Question 3

- 15612


>>select COUNT(1) from green_tripdata 
>>where DATE(lpep_pickup_datetime) = '2019-09-18' AND DATE(lpep_dropoff_datetime) = '2019-09-18';



### Question 4

- '2019-09-26' max_trip_distance(341.64)



>>SELECT
>>DATE(lpep_pickup_datetime) AS pickup_day,
>>MAX(trip_distance) AS max_trip_distance
>>FROM
>>green_tripdata
>>GROUP BY
>>pickup_day
>>ORDER BY
>>max_trip_distance DESC
>>LIMIT 1;



### Question 5

- Brookly 96333.24, manhatten 92271.3, queens 78681.71


>>Select 
>>	"Borough" as borough,
>>    SUM(total_amount) as amount

>>FROM taxi_zones as zones

>>INNER JOIN 
>>	green_taxi as taxi
>>ON 
>>	"PULocationID" = "LocationID"
>>WHERE 
>>	DATE(taxi.lpep_pickup_datetime) = '2019-09-18'
>>	AND "Borough" != 'Unknown'
>>GROUP BY 
>>	borough
>>HAVING 
>>	SUM(total_amount) > 50000;


### Question 6
 
-	JFKAirport

>>SELECT taxi_zonedata."Zone" from taxi_zonedata
>>JOIN 
>>(SELECT 
>>	"Borough", "Zone", "tip_amount", "DOLocationID"
>>FROM 
>>	taxi_zonedata
>>INNER JOIN
>>	green_tripdata
>>ON 
>>	"LocationID" = "PULocationID"
>>WHERE
>>	"Zone" = 'Astoria'
>>AND DATE(green_tripdata.lpep_pickup_datetime) BETWEEN '2019-09-01' AND'2019-09-30'
>>ORDER BY
>>	tip_amount DESC limit 1) as q1
>>ON "LocationID" = "DOLocationID"



### Question 7

output:

(base) veit@zoomcamp:~/data-engineering-zoomcamp/01-docker-terraform/1_terraform_gcp/terraform/terraform_with_variables$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_bigquery_dataset.demo_dataset will be created
  + resource "google_bigquery_dataset" "demo_dataset" {
      + creation_time              = (known after apply)
      + dataset_id                 = "zoomcamp_dataengineering_terra_bigquery"
      + default_collation          = (known after apply)
      + delete_contents_on_destroy = false
      + effective_labels           = (known after apply)
      + etag                       = (known after apply)
      + id                         = (known after apply)
      + is_case_insensitive        = (known after apply)
      + last_modified_time         = (known after apply)
      + location                   = "EU"
      + max_time_travel_hours      = (known after apply)
      + project                    = "zoomcamp-dataengineering"
      + self_link                  = (known after apply)
      + storage_billing_model      = (known after apply)
      + terraform_labels           = (known after apply)
    }

  # google_storage_bucket.demo-bucket will be created
  + resource "google_storage_bucket" "demo-bucket" {
      + effective_labels            = (known after apply)
      + force_destroy               = true
      + id                          = (known after apply)
      + location                    = "EU"
      + name                        = "zoomcamp-dataengineering-terra-bucket"
      + project                     = (known after apply)
      + public_access_prevention    = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + terraform_labels            = (known after apply)
      + uniform_bucket_level_access = (known after apply)
      + url                         = (known after apply)

      + lifecycle_rule {
          + action {
              + type = "AbortIncompleteMultipartUpload"
            }
          + condition {
              + age                   = 1
              + matches_prefix        = []
              + matches_storage_class = []
              + matches_suffix        = []
              + with_state            = (known after apply)
            }
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_bigquery_dataset.demo_dataset: Creating...
google_storage_bucket.demo-bucket: Creating...
google_bigquery_dataset.demo_dataset: Creation complete after 1s [id=projects/zoomcamp-dataengineering/datasets/zoomcamp_dataengineering_terra_bigquery]
google_storage_bucket.demo-bucket: Creation complete after 2s [id=zoomcamp-dataengineering-terra-bucket]
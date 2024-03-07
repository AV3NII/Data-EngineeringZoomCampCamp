


python 10-spark-submit.py \
   --input-green=../data/pq/green/2020/*/ \
   --input-yellow=../data/pq/yellow/2020/*/ \
   --output=../data/report-2020


URL='spark://zoomcamp.europe-west3-c.c.zoomcamp-dataengineering.internal:7077'

spark-submit \
    --master="${URL}" \
    10-spark-submit.py \
        --input-green=../data/pq/green/2021/*/ \
        --input-yellow=../data/pq/yellow/2021/*/ \
        --output=../data/report-2021


--input-green=gs://mage-zoomcamp-veit/pq/green/2021/*/ \
--input-yellow=gs://mage-zoomcamp-veit/pq/yellow/2021/*/ \
--output=gs://mage-zoomcamp-veit/report-2021



## Dataproc Cloud Cluster


gcloud dataproc jobs submit pyspark \
    --cluster=de-zoomcamp-cluster \
    --region=europe-west12 \
    gs://mage-zoomcamp-veit/code/10-spark-submit.py \
    -- \
    --input-green=gs://mage-zoomcamp-veit/pq/green/2021/*/ \
    --input-yellow=gs://mage-zoomcamp-veit/pq/yellow/2021/*/ \
    --output=gs://mage-zoomcamp-veit/report-2021 


gcloud dataproc jobs submit pyspark \
    --cluster=de-zoomcamp-cluster \
    --region=europe-west12 \
    --jars=gs://spark-lib/bigquery/spark-bigquery-latest_2.12.jar \
    gs://mage-zoomcamp-veit/code/10-spark-submit-bigquery.py \
    -- \
    --input-green=gs://mage-zoomcamp-veit/pq/green/2021/*/ \
    --input-yellow=gs://mage-zoomcamp-veit/pq/yellow/2021/*/ \
    --output=zoomcamp-dataengineering.dbt_vbrunnhuber.reports-2020
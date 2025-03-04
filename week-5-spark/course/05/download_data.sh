
# Execute 
    # download_data.sh "yellow" 2020
    # download_data.sh "yellow" 2021
    # download_data.sh "green" 2020
    # download_data.sh "green" 2021


set -e

TAXI_TYPE=$1 # "yellow"
YEAR=$2 # 2020

URL_PREFIX="https://github.com/DataTalksClub/nyc-tlc-data/releases/download"
RANGE=12


if [ $YEAR -eq 2021 ]; then
    RANGE=7
fi

for((MONTH=1; MONTH<=$RANGE; MONTH++)); do
    FMONTH=`printf "%02d" ${MONTH}`

    URL="${URL_PREFIX}/${TAXI_TYPE}/${TAXI_TYPE}_tripdata_${YEAR}-${FMONTH}.csv.gz"

    LOCAL_PREFIX="../data/raw/${TAXI_TYPE}/${YEAR}/${FMONTH}"
    LOCAL_FILE="${TAXI_TYPE}_tripdata_${YEAR}_${FMONTH}.csv.gz"
    LOCAL_PATH="${LOCAL_PREFIX}/${LOCAL_FILE}"

    echo "downloading ${URL} to ${LOCAL_PATH}"
    mkdir -p ${LOCAL_PREFIX}
    wget ${URL} -O ${LOCAL_PATH}

    echo "compressing ${LOCAL_PATH}"
    gzip ${LOCAL_PATH}

done



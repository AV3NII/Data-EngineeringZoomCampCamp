FROM python:3.9

RUN apt-get update && apt-get install -y wget
RUN pip install pandas sqlalchemy psycopg2 pyarrow

WORKDIR /app

COPY ingest_data.py ingest_data.py
COPY ingest_data1.py ingest_data1.py
COPY entrypoint.sh entrypoint.sh 

# Make entrypoint.sh executable
RUN chmod +x entrypoint.sh

# Use entrypoint.sh as the CMD
CMD ["./entrypoint.sh"]
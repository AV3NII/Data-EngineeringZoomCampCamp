#!/usr/bin/env python
# coding: utf-8


import pandas as pd
import argparse
import os

from sqlalchemy import create_engine
from time import time


def main(params):

    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    url = params.url
    csv_name = 'taxi_zonedata.csv'

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    os.system(f"wget {url} -O {csv_name}")

    if url.endswith(".gz"):
        df_iter = pd.read_csv(csv_name, iterator=True,compression='gzip', chunksize=100000, low_memory=False)

    elif url.endswith(".csv"):
        df_iter = pd.read_csv(csv_name, iterator=True, chunksize=100000, low_memory=False)
    else:
        print('data is not in csv or csv.gz')
        return


    df = next(df_iter)


    df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')
    df.to_sql(name=table_name, con=engine, if_exists='replace')


    while True:
        
    
        try:
            t_start = time()
            df = next(df_iter)
            df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
            df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)
            df.to_sql(name=table_name, con=engine, if_exists='append')
            t_end = time()
            print('inserted another chunck..., took %.3f second' %(t_end - t_start))
        except StopIteration:
            break



if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ingest CSV data to Postgres')


    parser.add_argument('--user', help='user name for postgres')      
    parser.add_argument('--password', help='password name for postgres')    
    parser.add_argument('--host', help='host name for postgres')   
    parser.add_argument('--port', help='port name for postgres')   
    parser.add_argument('--db', help='database name for postgres')    
    parser.add_argument('--table_name', help='name of table where we write the results to') 
    parser.add_argument('--url', help='url of the csv file')    


    args = parser.parse_args()

    main(args)

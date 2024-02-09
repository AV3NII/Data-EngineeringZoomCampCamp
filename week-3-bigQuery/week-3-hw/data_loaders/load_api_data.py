import io
import pandas as pd
import requests
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Template for loading data from API
    """
    urls = []
        
    for month in range(1,13):
        monthNum = str(month) if len(str(month)) == 2 else "0" + str(month)
        _url = f'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-{monthNum}.parquet'
        urls.append(_url)


    frames = []

    for url in urls:
        response = requests.get(url)
        response.raise_for_status()
        df_part = pd.read_parquet(url, engine='pyarrow')
        frames.append(df_part)


    return pd.concat(frames)



@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'

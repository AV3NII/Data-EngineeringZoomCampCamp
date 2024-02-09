import pandas as pd

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):

    no_passenger_counter = data.query('passenger_count == 0').shape[0]
    no_trip_distance_counter = data.query('trip_distance == 0').shape[0]

    print(f'Preprocessing: rows with zero passangers: {no_passenger_counter}')
    print(f'Preprocessing: rows with zero trip distance: {no_trip_distance_counter}')

    # remove trips with no distance &/or no passangers
    data = data.query('passenger_count != 0 & trip_distance != 0')

    # convert dateTime to date
    data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date
    data['lpep_dropoff_date'] = data['lpep_dropoff_datetime'].dt.date


    # rename columns and count the changes
    original_columns = list(data.columns)

    data.columns = [
        string.replace('ID', '_id')
            if 'ID' in string
            else string
        for string in data.columns
    ]

    data.columns = [
        string.replace('Location', '_location').lower()
            if 'Location' in string
            else string.lower()
        for string in data.columns
    ]


    transformation_count = sum(
        1 for original, transformed in zip(original_columns, data.columns)
            if original != transformed
    )

    print(f"Unique entries of vendor_id: {data['vendor_id'].unique()}")

    print(f"Total columns renamed: {transformation_count}")
    

    return data


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert 'vendor_id' in output.columns, "vendor_id is not one of the existing values."
    assert 'pu_location_id' in output.columns, "pu_location_id is not one of the existing values."
    assert 'do_location_id' in output.columns, "do_location_id is not one of the existing values."
    assert (output['passenger_count'] > 0).all(), "passenger_count is not greater than 0."
    assert (output['trip_distance'] > 0).all(), "trip_distance is not greater than 0."

    
    assert output is not None, 'The output is undefined'

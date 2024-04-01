

# Question 1
-> rpk version

v22.3.5 (rev 28b2443)

# Question 2
-> rpk topic create test-topic

TOPIC       STATUS
test-topic  OK

# Question 3 
returned True

# Question 4
Sent: {'number': 0}
Sent: {'number': 1}
Sent: {'number': 2}
Sent: {'number': 3}
Sent: {'number': 4}
Sent: {'number': 5}
Sent: {'number': 6}
Sent: {'number': 7}
Sent: {'number': 8}
Sent: {'number': 9}
Time spent sending messages: 0.51 seconds
Time spent flushing: 0.00 seconds
Total time taken: 0.51 seconds

# Question 5
-> 49 seconds

# Question 6
root
 |-- lpep_pickup_datetime: string (nullable = true)
 |-- lpep_dropoff_datetime: string (nullable = true)
 |-- PULocationID: integer (nullable = true)
 |-- DOLocationID: integer (nullable = true)
 |-- passenger_count: double (nullable = true)
 |-- trip_distance: double (nullable = true)
 |-- tip_amount: double (nullable = true)
 |-- timestamp: timestamp (nullable = true)

 # Question 7
 DOLocationID: 74
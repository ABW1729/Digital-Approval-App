import json
import time
import random
from kafka import KafkaProducer
from faker import Faker

producer = KafkaProducer(
    bootstrap_servers='localhost:9092',
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

fake = Faker()

TRANSACTION_TOPIC = "transactions"

MERCHANTS = ["Groceries", "Electronics", "Gaming", "Food", "Travel"]
TYPES = ["Debit", "Credit"]

# Simulated transaction sender
while True:
    txn = {
        "TransactionID": fake.uuid4(),
        "UserID": fake.uuid4(),
        "Amount": round(random.uniform(10.0, 10000.0), 2),
        "Timestamp": fake.iso8601(),
        "MerchantCategory": random.choice(MERCHANTS),
        "TransactionType": random.choice(TYPES),
        "DeviceID": fake.uuid4(),
        "IPAddress": fake.ipv4(),
        "Latitude": float(fake.latitude()),
        "Longitude": float(fake.longitude()),
        "AvgTransactionAmount": round(random.uniform(100.0, 2000.0), 2),
        "TransactionFrequency": random.randint(1, 20),
        "UnusualLocation": random.choice([0, 1]),
        "UnusualAmount": random.choice([0, 1]),
        "NewDevice": random.choice([0, 1]),
        "FailedAttempts": random.randint(0, 3),
        "PhoneNumber": fake.phone_number(),
        "BankName": fake.company()
    }
    
    producer.send(TRANSACTION_TOPIC, txn)
    time.sleep(3)  # adjustable rate

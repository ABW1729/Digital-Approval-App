from kafka import KafkaConsumer
import json
import pyttsx3

consumer = KafkaConsumer(
    'alerts',
    bootstrap_servers='localhost:9092',
    value_deserializer=lambda m: json.loads(m.decode('utf-8')),
    auto_offset_reset='earliest',
    enable_auto_commit=True
)

tts = pyttsx3.init()

print("[NOTIFIER] Listening for fraud alerts...")

for message in consumer:
    alert = message.value
    tx_id = alert.get("TransactionID", "Unknown")
    risk = alert.get("RiskLevel", 2)
    
    message_text = f"Alert! Fraud risk level {risk} detected in transaction {tx_id}."
    print(f"[NOTIFIER] {message_text}")

    # Speak out loud
    tts.say(message_text)
    tts.runAndWait()

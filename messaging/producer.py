import json
import uuid
import pika

# RabbitMQ Configuration
RABBITMQ_HOST = "localhost"
RABBITMQ_PORT = 5672
RABBITMQ_USER = "bankuser"
RABBITMQ_PASSWORD = "bankpassword"

QUEUE_NAME = "account-events"


def publish_account_created(account_id: int):
    # Credentials
    credentials = pika.PlainCredentials(
        username=RABBITMQ_USER,
        password=RABBITMQ_PASSWORD
    )

    # Connection
    connection = pika.BlockingConnection(
        pika.ConnectionParameters(
            host=RABBITMQ_HOST,
            port=RABBITMQ_PORT,
            credentials=credentials
        )
    )

    channel = connection.channel()

    # Declare Queue
    channel.queue_declare(
        queue=QUEUE_NAME,
        durable=True
    )

    # Event
    event = {
        "event_id": str(uuid.uuid4()),
        "event_type": "AccountCreated",
        "account_id": account_id
    }

    # Publish
    channel.basic_publish(
        exchange="",
        routing_key=QUEUE_NAME,
        body=json.dumps(event),
        properties=pika.BasicProperties(
            delivery_mode=2,
            content_type="application/json"
        )
    )

    print("=" * 60)
    print("✅ Event Published Successfully")
    print(json.dumps(event, indent=2))
    print("=" * 60)

    connection.close()


if __name__ == "__main__":
    publish_account_created(1)

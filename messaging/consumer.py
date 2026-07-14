import json
import time
import pika
import psycopg2

# -----------------------------
# RabbitMQ Configuration
# -----------------------------
RABBITMQ_HOST = "localhost"
RABBITMQ_PORT = 5672
RABBITMQ_USER = "bankuser"
RABBITMQ_PASSWORD = "bankpassword"

QUEUE_NAME = "account-events"
DLQ_NAME = "account-events-dlq"

# -----------------------------
# PostgreSQL Configuration
# -----------------------------
DB_HOST = "localhost"
DB_PORT = 5432
DB_NAME = "bankdb"
DB_USER = "bank_app"
DB_PASSWORD = "bank_password"


def get_db_connection():
    return psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )


def process_event(event):

    conn = get_db_connection()
    cur = conn.cursor()

    try:
        event_id = event["event_id"]

        # Idempotency check
        cur.execute("""
            INSERT INTO processed_events(event_id)
            VALUES(%s)
            ON CONFLICT DO NOTHING
            RETURNING event_id;
        """, (event_id,))

        inserted = cur.fetchone()

        if inserted is None:
            print(f"[INFO] Duplicate event ignored: {event_id}")
            conn.commit()
            return

        # Side effect
        cur.execute("""
            INSERT INTO audit_log(account_id, event_type)
            VALUES(%s, %s)
        """, (
            event["account_id"],
            event["event_type"]
        ))

        conn.commit()

        print(f"[SUCCESS] Event processed: {event_id}")

    except Exception as e:
        conn.rollback()
        raise e

    finally:
        cur.close()
        conn.close()


def callback(ch, method, properties, body):

    try:

        event = json.loads(body)

        process_event(event)

        ch.basic_ack(delivery_tag=method.delivery_tag)

    except Exception as e:

        print("[ERROR]", e)

        retry_count = 0

        if properties.headers:
            retry_count = properties.headers.get("x-retry", 0)

        if retry_count >= 3:

            ch.basic_publish(
                exchange="",
                routing_key=DLQ_NAME,
                body=body
            )

            print("[DLQ] Message moved to Dead Letter Queue")

        else:

            headers = {"x-retry": retry_count + 1}

            ch.basic_publish(
                exchange="",
                routing_key=QUEUE_NAME,
                body=body,
                properties=pika.BasicProperties(
                    headers=headers
                )
            )

            print(f"[Retry] Attempt {retry_count+1}")

        ch.basic_ack(delivery_tag=method.delivery_tag)


def start_consumer():

    credentials = pika.PlainCredentials(
        RABBITMQ_USER,
        RABBITMQ_PASSWORD
    )

    while True:

        try:

            connection = pika.BlockingConnection(
                pika.ConnectionParameters(
                    host=RABBITMQ_HOST,
                    port=RABBITMQ_PORT,
                    credentials=credentials
                )
            )

            channel = connection.channel()

            channel.queue_declare(
                queue=QUEUE_NAME,
                durable=True
            )

            channel.queue_declare(
                queue=DLQ_NAME,
                durable=True
            )

            channel.basic_qos(prefetch_count=1)

            channel.basic_consume(
                queue=QUEUE_NAME,
                on_message_callback=callback
            )

            print("=" * 60)
            print("RabbitMQ Consumer Started")
            print("=" * 60)

            channel.start_consuming()

        except Exception as e:

            print("[Connection Error]", e)
            print("Retrying in 5 seconds...")

            time.sleep(5)


if __name__ == "__main__":
    start_consumer()

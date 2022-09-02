from confluent_kafka import avro
import json
import uuid
import time
import os
import randomname
import confluent_kafka

from confluent_kafka.avro import AvroProducer
from utils.load_avro_schema_from_file import load_avro_schema_from_file


schema_file = 'sr-linking-schema-demo.avsc'
schema_registry = 'http://schemaregistry-bootstrap-destination-lb:80'
bootstrap_servers = 'kafka-bootstrap-source-lb:9092'
topic = 'sr-linking-topic-demo-sources'
loop_count = 800


def send_record():
    key_schema, value_schema = load_avro_schema_from_file(schema_file)
    producer_config = {
        "bootstrap.servers": bootstrap_servers,
        "schema.registry.url": schema_registry
    }

    producer = AvroProducer(producer_config, default_key_schema=key_schema, default_value_schema=value_schema)

    record = dict()
    n = 1
    while n < loop_count:
        print(n)
        record['email'] = randomname.get_name()
        record['firstName'] = randomname.get_name()
        record['lastName'] = randomname.get_name()
        json_value = json.dumps(record)
        key = str(uuid.uuid4())

        try:
            producer.produce(topic=topic, key=key, value=record)
        except Exception as e:
            print(f"Exception while producing record value - {json_value} to topic - {topic}: {e}")
        else:
            print(f"Successfully producing record value - {json_value} to topic - {topic}")
        producer.flush()
        time.sleep(1)


if __name__ == "__main__":
    send_record()


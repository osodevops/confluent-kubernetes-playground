from confluent_kafka import DeserializingConsumer
from confluent_kafka.schema_registry import SchemaRegistryClient
from confluent_kafka.schema_registry.avro import AvroDeserializer
from confluent_kafka.serialization import StringDeserializer

schema_file = 'sr-linking-schema-demo.avsc'
schema_registry = 'http://schemaregistry-bootstrap-lb:80'
bootstrap_servers = 'kafka-bootstrap-lb:9092'
topic = 'sr-linking-topic-demo-sources'

def consume_record():
    sr_conf = {'url': schema_registry}
    schema_registry_client = SchemaRegistryClient(sr_conf)

    avro_deserializer = AvroDeserializer(schema_registry_client,
                                         schema_str,
                                         dict_to_user)
    string_deserializer = StringDeserializer('utf_8')

    consumer_conf = {'bootstrap.servers': bootstrap_servers,
                         'key.deserializer': string_deserializer,
                         'value.deserializer': avro_deserializer,
                         'group.id': args.group,
                         'auto.offset.reset': "earliest"}


if __name__ == "__main__":
    consume_record()


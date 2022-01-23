#!/bin/bash

curl --insecure --cert ./alpha-client.pem --key ./alpha-client-key.pem -X POST 'https://localhost:8082/topics/rt-testtopic' \
--header 'Content-Type: application/vnd.kafka.json.v2+json' \
--data '{"records" : [{ "value" : { "foo" : "bar", "testdata" : 1}}]}'


> /tmp/command.properties && \
echo "bootstrap.servers=kafka:9071" >> /tmp/command.properties && \
echo 'sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="kafka" password="kafka-secret";' >> /tmp/command.properties && \
echo "sasl.mechanism=PLAIN" >> /tmp/command.properties && \
echo "security.protocol=SSL" >> /tmp/command.properties && \
echo "ssl.truststore.location=/mnt/sslcerts/truststore.jks" >> /tmp/command.properties && \
echo "ssl.truststore.password=mystorepassword" >> /tmp/command.properties && \
echo "ssl.keystore.location=/mnt/sslcerts/keystore.jks" >> /tmp/command.properties && \
echo "ssl.keystore.password=mystorepassword" >> /tmp/command.properties

kafka-acls --bootstrap-server kafka:9071 --command-config /tmp/command.properties --list

kafka-acls --bootstrap-server kafka:9071 --command-config /tmp/command.properties \
 --add \
 --allow-principal "User:alpha.sandbox.svc.cluster.local" \
 --operation All \
 --topic rt-testtopic \
 --topic alpha-topic


kafka-acls --bootstrap-server kafka:9071 --command-config /tmp/command.properties \
 --add \
 --allow-principal "User:producer-1" \
 --operation All \
 --topic rt-testtopic \
 --topic alpha-topic
1. cd into `/examples/custom-connect`

2. start minikube
```shell
minikube start --cpus=6 --memory=16384
```

3. apply CFK crds and Componets 
```shell
kubectl apply -k ../../base/crds && kubectl apply -k .
```

4. run docker build for connect image into minikube
```shell
cd docker
./build-inside.sh
```   

[//]# (TODO) There is no such service-account.json 
6. create google service account secret which is used in the connect config
```shell
 kubectl create secret generic gcs-service-account --from-file=./gcs-connect/service-account.json -n sandbox
```

7. Port forward the connect cluster to create connect task:
```shell
kubectl port-forward -n sandbox gcsconnect-0 8083:8083
```

8. Create connectors using sample JSON
```shell
cd gcs-connect
# GCS example connector
curl -XPUT -H "Content-Type: application/json" --data @gcs-connect/gcs-sink.json -u kafka:kafka-secret https://localhost:8083/connectors/gcs-sink/config -kv

# Spanner Sink connector
curl -XPUT -H "Content-Type: application/json" --data @spanner-sink.json -u kafka:kafka-secret https://localhost:8083/connectors/spanner-sink-connector/config -kv
```


if successfully:
```shell
* Connection #0 to host localhost left intact
{"name":"gcs-sink","config":{"name":"gcs-sink","connector.class":"io.confluent.connect.gcs.GcsSinkConnector","tasks.max":"1","topics":"topic-in-source","gcs.bucket.name":"lloyds-kafka-example","gcs.part.size":"5242880","flush.size":"1","gcs.credentials.path":"/mnt/secrets/gcs-service-account/service-account.json","storage.class":"io.confluent.connect.gcs.storage.GcsStorage","format.class":"io.confluent.connect.gcs.format.avro.AvroFormat","partitioner.class":"io.confluent.connect.storage.partitioner.DefaultPartitioner","schema.compatibility":"NONE","confluent.topic.bootstrap.servers":"kafka.sandbox.svc.cluster.local:9071","confluent.topic.replication.factor":"1","confluent.topic.ssl.truststore.location":"/mnt/sslcerts/truststore.p12","confluent.topic.ssl.truststore.password":"mystorepassword","confluent.topic.ssl.truststore.type":"PKCS12","confluent.topic.security.protocol":"SASL_SSL","confluent.topic.sasl.mechanism":"PLAIN","confluent.topic.sasl.jaas.config":"org.apache.kafka.common.security.plain.PlainLoginModule required username=\"connect\" password=\"connect-secret\";"},"tasks":[],"type":"sink"}* Closing connection 0
```

9. Produce some data to sync to bucket
```shell
# exec into kafka pod 
kubectl exec -n sandbox -it kafka-0 -- bash

# create client properties file to connect to cluster
cat <<EOF > kafka.properties
bootstrap.servers=kafka.sandbox.svc.cluster.local:9071
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username=kafka password=kafka-secret;
sasl.mechanism=PLAIN
security.protocol=SASL_SSL
ssl.truststore.location=/mnt/sslcerts/truststore.p12
ssl.truststore.password=mystorepassword
ssl.truststore.type=PKCS12
EOF

# start console consumer to produce JSON messages
kafka-console-producer --bootstrap-server kafka.sandbox.svc.cluster.local:9071 --topic topic-in-source --producer.config ./kafka.properties

# copy and paste some sample JSON
{"title":"The Matrix","year":1999,"cast":["Keanu Reeves","Laurence Fishburne","Carrie-Anne Moss","Hugo Weaving","Joe Pantoliano"],"genres":["Science Fiction"]}

{"title":"Die Hard","year":1988,"cast":["Bruce Willis","Alan Rickman","Bonnie Bedelia","William Atherton","Paul Gleason","Reginald VelJohnson","Alexander Godunov"],"genres":["Action"]} 

{"title":"Toy Story","year":1995,"cast":["Tim Allen","Tom Hanks","(voices)"],"genres":["Animated"]} 

{"title":"Jurassic Park","year":1993,"cast":["Sam Neill","Laura Dern","Jeff Goldblum","Richard Attenborough"],"genres":["Adventure"]} 

{"title":"The Lord of the Rings: The Fellowship of the Ring","year":2001,"cast":["Elijah Wood","Ian McKellen","Liv Tyler","Sean Astin","Viggo Mortensen","Orlando Bloom","Sean Bean","Hugo Weaving","Ian Holm"],"genres":["Fantasy"]} 
```

## Notes
- Delete the connector using `curl -X DELETE -u connect:connect-secret https://localhost:8083/connectors/gcs-sink -kv`
- Delete the topic using: `kafka-topics --bootstrap-server kafka.sandbox.svc.cluster.local:9071 --delete --topic topic-in-source --command-config ./kafka.properties`
- Create the topic again using: `kafka-topics --bootstrap-server kafka.sandbox.svc.cluster.local:9071 --create --topic topic-in-source --command-config ./kafka.properties --replication-factor 3 --partitions 4`

- Kafkacat commands:
```shell
kafkacat -b kafka.sandbox.svc.cluster.local:9071 \
    -X security.protocol=sasl_ssl \
    -X sasl.mechanisms=PLAIN \
    -X sasl.username=connect \
    -X sasl.password=connect-secret \
    -X ssl.key.location=/mnt/secrets/privkey.pem \
    -X ssl.certificate.location=/mnt/secrets/fullchain.pem \
    -X ssl.ca.location=/mnt/secrets/cacerts.pem \
    -L

kafkacat -b kafka.sandbox.svc.cluster.local:9071 \
    -X security.protocol=sasl_ssl \
    -X sasl.mechanisms=PLAIN \
    -X sasl.username=connect \
    -X sasl.password=connect-secret \
    -X ssl.key.location=/mnt/secrets/privkey.pem \
    -X ssl.certificate.location=/mnt/secrets/fullchain.pem \
    -X ssl.ca.location=/mnt/secrets/cacerts.pem \
    -P -t topic-in-source -T -l ./data.json
```
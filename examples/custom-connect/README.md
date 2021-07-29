1. cd into `/examples/custom-connect`

2. start minikube
```shell
minikube start --cpus=6 --memory=16384
```

3. apply confluent crds 
```shell
kubectl apply -k ../../kustomize/infrastructure
```

4. run docker build for connect image into minikube
```shell
./build-inside.sh
```   

5. deploy confluent platform and connector
```shell
kubectl apply -k .
```

6. create google service account secret which is used in the connect config
```shell
 kubectl create secret generic gcs-service-account --from-file=./service-account.json -n sandbox
```

cat <<EOF > gcs-sink.json
{
"name": "gcs-sink",
"config": {
"connector.class": "io.confluent.connect.gcs.GcsSinkConnector",
"tasks.max": "1",
"topics": "foobar",
"gcs.bucket.name": "lloyds-kafka-example",
"gcs.part.size": "5242880",
"flush.size": "1",
"gcs.credentials.path": "/mnt/secrets/gcs-service-account/service-account.json",
"storage.class": "io.confluent.connect.gcs.storage.GcsStorage",
"format.class": "io.confluent.connect.gcs.format.avro.AvroFormat",
"partitioner.class": "io.confluent.connect.storage.partitioner.DefaultPartitioner",
"schema.compatibility": "NONE",
"confluent.topic.bootstrap.servers": "kafka.sandbox.svc.cluster.local:9071",
"confluent.topic.replication.factor": "1"
}
}
EOF

curl -XPOST -H "Content-Type: application/json" --data @gcs-sink.json -u testadmin:testadmin https://localhost:8083/connectors -kv
#!/bin/bash
cfssl gencert -initca base-ca-csr.json | cfssljson -bare ./root-ca -

# Create Zookeeper server certificates
# Use the SANs listed in zookeeper-server-domain.json

cfssl gencert -ca=root-ca.pem \
-ca-key=root-ca-key.pem \
-config=base-ca-config.json \
-profile=server zookeeper-server-domain.json | cfssljson -bare zookeeper-server

kubectl create secret generic tls-zookeeper \
  --dry-run=client \
  --from-file=fullchain.pem=./zookeeper-server.pem \
  --from-file=cacerts.pem=./root-ca.pem \
  --from-file=privkey.pem=./zookeeper-server-key.pem -o yaml > zookeeper-sslcerts.yaml

# Create Kafka server certificates
# Use the SANs listed in kafka-server-domain.json
cfssl gencert -ca=root-ca.pem \
-ca-key=root-ca-key.pem \
-config=base-ca-config.json \
-profile=server kafka-server-domain.json | cfssljson -bare kafka-server

kubectl create secret generic tls-kafka \
  --dry-run=client \
  --from-file=fullchain.pem=./kafka-server.pem \
  --from-file=cacerts.pem=./root-ca.pem \
  --from-file=privkey.pem=./kafka-server-key.pem -o yaml > kafka-sslcerts.yaml

# Create Client Certificates
# Use the SANs listed in kafka-server-domain.json
cfssl gencert -ca=root-ca.pem \
-ca-key=root-ca-key.pem \
-config=base-ca-config.json \
-profile=server client-producer.json | cfssljson -bare kafka-client

kubectl create secret generic tls-kafka \ connect to your Kafka cluster(s).
  --dry-run=client \
  --from-file=fullchain.pem=./kafka-client.pem \
  --from-file=cacerts.pem=./root-ca.pem \
  --from-file=privkey.pem=./kafka-client-key.pem -o yaml > kafka-client-sslcerts.yaml
#!/bin/bash
kubectl create secret generic credential \
--from-file=plain-users.json=./users/creds-kafka-sasl-users.json \
--from-file=digest-users.json=./users/creds-zookeeper-sasl-digest-users.json \
--from-file=digest.txt=./users/creds-kafka-zookeeper-credentials.txt \
--from-file=plain.txt=./users/creds-client-kafka-sasl-user.txt \
--from-file=basic.txt=./users/creds-control-center-users.txt \
--from-file=ldap.txt=./users/ldap.txt \
--from-file=mdsPublicKey.pem=./certs/mds-publickey.txt \
--from-file=mdsTokenKeyPair.pem=./certs/mds-tokenkeypair.txt \
--dry-run=client --output=yaml > ../../base/secrets/credential.yaml

kubectl create secret generic mds-token \
--from-file=mdsPublicKey.pem=./certs/mds-publickey.txt \
--from-file=mdsTokenKeyPair.pem=./certs/mds-tokenkeypair.txt \
--dry-run=client --output=yaml > ../../base/secrets/mds-token.yaml

# Kafka RBAC credential
kubectl create secret generic mds-client \
--from-file=bearer.txt=./users/bearer.txt \
--dry-run=client --output=yaml > ../../base/secrets/mds-client.yaml
# Control Center RBAC credential
kubectl create secret generic c3-mds-client \
--from-file=bearer.txt=./users/c3-mds-client.txt \
--from-file=basic.txt=./users/c3-mds-client.txt \
--dry-run=client --output=yaml > ../../base/secrets/c3-mds-client.yaml
# Connect RBAC credential
kubectl create secret generic connect-mds-client \
--from-file=bearer.txt=./users/connect-mds-client.txt \
--dry-run=client --output=yaml > ../../base/secrets/connect-mds-client.yaml
# Schema Registry RBAC credential
kubectl create secret generic sr-mds-client \
--from-file=bearer.txt=./users/sr-mds-client.txt \
--dry-run=client --output=yaml > ../../base/secrets/sr-mds-client.yaml
# ksqlDB RBAC credential
kubectl create secret generic ksqldb-mds-client \
--from-file=bearer.txt=./users/ksqldb-mds-client.txt \
--dry-run=client --output=yaml > ../../base/secrets/ksqldb-mds-client.yaml
# Kafka REST credential
kubectl create secret generic rest-credential \
--from-file=bearer.txt=./users/bearer.txt \
--from-file=basic.txt=./users/bearer.txt \
--from-file=plain.txt=./users/bearer.txt \
--dry-run=client --output=yaml > ../../base/secrets/rest-credential.yaml

# Confluent licensing
kubectl create secret generic confluent-operator-licensing \
--from-file=license.txt=./licensing/license-key.txt \
--from-file=publicKey.pem=./licensing/license-pem.txt \
--dry-run=client --output=yaml > ../../base/secrets/confluent-license.yaml
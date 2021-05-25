#!/bin/bash
kubectl create secret generic broker-credential \
--from-file=digest.txt=./users/creds-kafka-zookeeper-credentials.txt \
--from-file=ldap.txt=./users/ldap.txt \
--from-file=plain-jaas.conf=./users/plain-jaas.conf \
--from-file=bearer.txt=./users/bearer.txt \
--from-file=mdsTokenKeyPair.pem=./certs/mds-tokenkeypair.txt \
--from-file=mdsPublicKey.pem=./certs/mds-publickey.txt \
--dry-run=client --output=yaml > ../../kustomize/base/secrets/broker-credential.yaml

kubectl create secret generic zk-credential \
--from-file=digest-users.json=./users/creds-zookeeper-sasl-digest-users.json \
--dry-run=client --output=yaml > ../../kustomize/base/secrets/zk-credential.yaml

kubectl create secret generic mds-public \
--from-file=mdsPublicKey.pem=./certs/mds-publickey.txt \
--dry-run=client --output=yaml > ../../kustomize/base/secrets/mds-public.yaml
# Control Center RBAC credential
kubectl create secret generic mds-client-c3 \
--from-file=bearer.txt=./users/mds-client-c3.txt \
--from-file=plain.txt=./users/mds-client-c3.txt \
--dry-run=client --output=yaml > ../../kustomize/base/secrets/mds-client-c3.yaml
# Connect RBAC credential
kubectl create secret generic mds-client-connect \
--from-file=bearer.txt=./users/mds-client-connect.txt \
--from-file=plain.txt=./users/mds-client-connect.txt \
--dry-run=client --output=yaml > ../../kustomize/base/secrets/mds-client-connect.yaml
# Schema Registry RBAC credential
kubectl create secret generic mds-client-sr \
--from-file=bearer.txt=./users/mds-client-sr.txt \
--from-file=plain.txt=./users/mds-client-sr.txt \
--dry-run=client --output=yaml > ../../kustomize/base/secrets/mds-client-sr.yaml
# ksqlDB RBAC credential
kubectl create secret generic mds-client-ksqldb \
--from-file=bearer.txt=./users/mds-client-ksqldb.txt \
--from-file=plain.txt=./users/mds-client-ksqldb.txt \
--dry-run=client --output=yaml > ../../kustomize/base/secrets/mds-client-ksqldb.yaml
# Kafka REST credential
kubectl create secret generic rest-credential \
--from-file=bearer.txt=./users/bearer.txt \
--dry-run=client --output=yaml > ../../kustomize/base/secrets/rest-credential.yaml

# Confluent licensing
kubectl create secret generic confluent-operator-licensing \
--from-file=license.txt=./licensing/license-key.txt \
--from-file=publicKey.pem=./licensing/license-pem.txt \
--dry-run=client --output=yaml > ../../kustomize/base/secrets/confluent-license.yaml
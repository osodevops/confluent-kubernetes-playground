#!/bin/bash
kubectl create secret generic credential \
--from-file=basic.txt=./basic.txt \
--from-file=bearer.txt=./bearer.txt \
--from-file=digest.txt=./digest.txt \
--from-file=digest-users.json=./digest-users.json \
--from-file=ldap.txt=./ldap.txt \
--from-file=mdsPublicKey.pem=./mdsPublicKey.pem \
--from-file=mdsTokenKeyPair.pem=./mdsTokenKeyPair.pem \
--from-file=plain.txt=./plain.txt \
--from-file=plain-jaas.conf=./plain-jaas.conf \
--from-file=plain-users.json=./plain-users.json \
--dry-run=client --output=yaml > ../../base/secrets/credential.yaml

kubectl create secret tls ca-pair-sslcerts \
--cert=./ca.pem \
--key=./ca-key.pem \
--dry-run=client --output=yaml > ../../base/secrets/ca-pair-sslcerts.yaml

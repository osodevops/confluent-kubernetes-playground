#!/bin/bash
# This will generate the files:
# * sensitive-ca.csr
# * sensitive-ca.pem
# * sensitive-ca-key.pem
cfssl gencert -initca base-ca-csr.json | cfssljson -bare ./sensitive-ca -

# Verify with this:
openssl x509 -in sensitive-ca.pem -text -noout


# This will generate the files:
# * sensitive-dc1.csr
# * sensitive-dc1.pem
# * sensitive-dc1-key.pem
cfssl gencert -ca=./sensitive-ca.pem -ca-key=./sensitive-ca-key.pem -config=./base-ca-config.json -profile=server dc1-domain.json | cfssljson -bare sensitive-dc1
# Verify with this:
openssl x509 -in sensitive-dc1.pem -text -noout

## CREATE KUBERNETES SECRETS
# DC1 Certificates
kubectl create secret generic credential-operator --dry-run=client \
--from-file=fullchain.pem=./sensitive-dc1.pem \
--from-file=privkey.pem=./sensitive-dc1-key.pem \
--from-file=cacerts.pem=./sensitive-ca.pem -o yaml > ./credential-operator.yaml

# This is required for 'auto-generated' example
kubectl create secret tls ca-pair-sslcerts \
--dry-run=client \
--cert=sensitive-ca.pem \
--key=sensitive-ca-key.pem -o yaml > ./generic-ca-pair-sslcerts.yaml

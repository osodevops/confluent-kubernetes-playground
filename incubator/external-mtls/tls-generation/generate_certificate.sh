#!/bin/bash
cfssl gencert -initca base-ca-csr.json | cfssljson -bare ./sensitive-ca -
# Verify with this:
#openssl x509 -in sensitive-ca.pem -text -noout
cfssl gencert -ca=./sensitive-ca.pem -ca-key=./sensitive-ca-key.pem -config=./base-ca-config.json -profile=server base-server-domain.json | cfssljson -bare sensitive-server
# This is required for 'auto-generated' example
kubectl create secret tls ca-pair-sslcerts \
--dry-run=client \
--cert=sensitive-ca.pem \
--key=sensitive-ca-key.pem -o yaml > ./ca-pair-sslcerts.yaml


# this is required for the 'custom-tls' example
kubectl create secret generic tls-group1 \
  --dry-run=client \
  --from-file=fullchain.pem=./sensitive-server.pem \
  --from-file=cacerts.pem=./sensitive-ca.pem \
  --from-file=privkey.pem=./sensitive-server-key.pem -o yaml > ../../kustomize/base/secrets-tls/tls-group1.yaml



md5sum sensitive-ca.pem
md5sum sensitive-server.pem
rm sensitive-*
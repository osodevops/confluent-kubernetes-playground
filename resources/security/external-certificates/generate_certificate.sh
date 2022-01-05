#!/bin/bash
cfssl gencert -initca base-ca-csr.json | cfssljson -bare ./sensitive-ca -
# Verify with this:
#openssl x509 -in sensitive-ca.pem -text -noout
cfssl gencert -ca=./sensitive-ca.pem -ca-key=./sensitive-ca-key.pem -config=./base-ca-config.json -profile=server abc-domain.json | cfssljson -bare sensitive-server

cfssl gencert -ca=./sensitive-ca.pem -ca-key=./sensitive-ca-key.pem -config=./base-ca-config.json -profile=server client-abc-domain.json | cfssljson -bare sensitive-client
# Verify with this:
#openssl x509 -in sensitive-server.pem -text -noout

# this is required for the 'custom-tls' example
kubectl create secret generic abc-tls \
  --dry-run=client \
  --from-file=fullchain.pem=./sensitive-server.pem \
  --from-file=cacerts.pem=./sensitive-ca.pem \
  --from-file=privkey.pem=./sensitive-server-key.pem -o yaml > ./abc-tls.yaml

# This is required for 'auto-generated' example
kubectl create secret tls ca-pair-sslcerts \
--dry-run=client \
--cert=sensitive-ca.pem \
--key=sensitive-ca-key.pem -o yaml > ./abc-ca-pair-sslcerts.yaml

md5sum sensitive-ca.pem
md5sum sensitive-server.pem

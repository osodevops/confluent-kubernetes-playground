#!/bin/bash
cfssl gencert -initca base-ca-csr.json | cfssljson -bare ./sensitive-ca -
# Verify with this:
#openssl x509 -in sensitive-ca.pem -text -noout
cfssl gencert -ca=./sensitive-ca.pem -ca-key=./sensitive-ca-key.pem -config=./base-ca-config.json -profile=server base-server-domain.json | cfssljson -bare sensitive-server
# Verify with this:
#openssl x509 -in sensitive-server.pem -text -noout

kubectl create secret -n production generic tls-group1 \
  --dry-run=client \
  --from-file=fullchain.pem=./sensitive-server.pem \
  --from-file=cacerts.pem=./sensitive-ca.pem \
  --from-file=privkey.pem=./sensitive-server-key.pem -o yaml | kubectl replace -f -
kubectl create secret -n production tls ca-pair-sslcerts \
--dry-run=client \
--cert=sensitive-ca.pem \
--key=sensitive-ca-key.pem -o yaml | kubectl replace -f -

kubectl create secret -n dev tls ca-pair-sslcerts \
--dry-run=client \
--cert=./sensitive-ca.pem \
--key=./sensitive-ca-key.pem -o yaml | kubectl replace -f -

md5sum sensitive-ca.pem
md5sum sensitive-server.pem
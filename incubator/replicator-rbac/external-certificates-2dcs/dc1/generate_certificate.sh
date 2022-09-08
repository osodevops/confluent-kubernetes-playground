#!/bin/bash
# This will generate the files:
# * sensitive-ca.csr
# * sensitive-ca.pem
# * sensitive-ca-key.pem
cfssl gencert -initca base-ca-csr.json | cfssljson -bare ./sensitive-ca -

# This will generate the files:
# * sensitive-dc1.csr
# * sensitive-dc1.pem
# * sensitive-dc1-key.pem
cp sensitive-ca.pem ../dc2
cp sensitive-ca-key.pem ../dc2
cfssl gencert -ca=./sensitive-ca.pem -ca-key=./sensitive-ca-key.pem -config=./base-ca-config.json -profile=server dc1-domain.json | cfssljson -bare sensitive-dc1

mv sensitive-dc1.pem fullchain.pem
mv sensitive-dc1-key.pem privkey.pem
mv sensitive-ca.pem cacerts.pem


#!/bin/bash
cfssl gencert -ca=./sensitive-ca.pem -ca-key=./sensitive-ca-key.pem -config=./base-ca-config.json -profile=server dc2-domain.json | cfssljson -bare sensitive-dc1

mv sensitive-dc1.pem fullchain.pem
mv sensitive-dc1-key.pem privkey.pem
mv sensitive-ca.pem cacerts.pem


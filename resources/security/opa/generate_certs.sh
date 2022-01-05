#!/usr/bin/env bash

openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -days 100000 -out ca.crt -subj "/CN=admission_ca"

openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr -config server.conf
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 100000 -extensions v3_req -extfile server.conf

kubectl create secret tls opa-server \
--dry-run=client \
--cert=server.crt \
--key=server.key -o yaml > ../../examples/multi-tenacy/open-policy-agent/opa-server.yaml
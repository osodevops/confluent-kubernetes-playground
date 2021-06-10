#!/bin/bash -e

# Root CA certificate
openssl req -new -nodes -x509 -days 3650 -newkey rsa:2048 -keyout ca.key -out ca.crt -config ca.cnf

# Intermediate SSL CA certificate
#generate_certificate \
#  sslca \
#  "/UK/O=OSO/OU=Labs POC/CN=SSL CA" \
#  "basicConstraints=CA:TRUE\nkeyUsage=digitalSignature,keyCertSign" \
#  rootca
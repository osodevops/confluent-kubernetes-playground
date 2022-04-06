#!/bin/bash

kubectl create secret generic aws-cred-mount \
--from-file=credentials=./sensitive-aws.credentials \
--from-file=config=./aws.config \
--dry-run=client --output=yaml > ./sensitive-aws-cred-mount.yaml
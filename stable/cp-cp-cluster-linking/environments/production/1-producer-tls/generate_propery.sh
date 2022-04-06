#!/bin/bash

kubectl create secret generic kafka-client-config \
--from-file=kafka.properties=./kafka.properties \
--dry-run=client --output=yaml > ./kafka-client-config.yaml
#!/bin/bash

nohup kubectl port-forward -n destination replicator-0 8083:8083 &

sleep 2

curl -XPOST -H "Content-Type: application/json" --data @replicator.json -u testadmin:testadmin https://localhost:8083/connectors -kv
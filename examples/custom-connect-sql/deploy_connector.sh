#!/bin/bash
nohup kubectl port-forward -n destination connect-0 8083:8083 &
sleep 2
curl -XPOST -H "Content-Type: application/json" --data @prod-mssql-connector.json https://localhost:8083/connectors -kv
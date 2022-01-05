#!/bin/bash
export CONNECTOR_CONFIG=$(cat ./prod-mssql-connector.json)
kubectl exec -i connect-0 -c connect -- curl -u kafka:kafka-secret -v -k -X PUT -H 'Content-Type:application/json' -d "$CONNECTOR_CONFIG" https://localhost:8083/connectors/debezium-sql-server/config
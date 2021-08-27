#!/bin/bash
kubectl config set-context --current --namespace=sandbox
export UPDATE_CONFIG=$(cat ./update.sql)
kubectl exec sql-server -n sandbox -- /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "nbBg8G4DkR83Xs" -q "$UPDATE_CONFIG" && exit

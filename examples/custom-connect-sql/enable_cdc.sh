#!/bin/bash
kubectl config set-context --current --namespace=sandbox
kubectl exec -i sql-server -- \
tee -a /tmp/person.sql > /dev/null <<EOT
USE AdventureWorks;
GO
EXEC sp_changedbowner 'sa'
GO
EXEC sys.sp_cdc_enable_db;
GO
EXEC sys.sp_cdc_enable_table
     @source_schema = N'person',
     @source_name   = N'person',
     @role_name     = N'MyRole',
     @filegroup_name = N'Primary',
     @supports_net_changes = 0
GO
EOT

kubectl exec -it sql-server -- \
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "nbBg8G4DkR83Xs" -i  /tmp/person.sql






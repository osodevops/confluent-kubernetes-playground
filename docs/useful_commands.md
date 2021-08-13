## Useful Commands 

### MDS 
- Validate MDS up and running
```shell
curl -vi https://kafka.sandbox.svc.cluster.local:8090/security/1.0/activenodes/https
```

### Replicator
- Create connect

- Delete connector
```shell
  curl -XDELETE -u testadmin:testadmin https://localhost:8083/connectors/replicator-4 -k
```
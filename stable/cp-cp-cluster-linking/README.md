# Cluster Linking (Confluent Platform -> Confluent Platform)
This example deploys a multi-tenant solution that exhibits how to perform Confluent Platform to Confluent Platform clusterlinking

## Features

| Feature         | Enabled | Note                                                                              |
|:----------------|:-------:|:----------------------------------------------------------------------------------|
| Kafka/Zookeeper |    ✅    |                                                                                   |
| Control Center  |    ✅    |                                                                                   |
| Connect         |    ❌    |                                                                                   |
| Schema Registry |    ❌    |                                                                                   |
| KSQL            |    ❌    |                                                                                   |
| TLS Encryption  |    ✅    | Self-signed certificates                                                          |
| Authentication  |    ✅    | RBAC                                                                              |
| Authorization   |    ✅    | via LDAP and mTLS (inter-component)                                               |
| Multi-tenant    |    ✅    | Production and Failover environments running on same cluster                      |
| Cluster Linking |    ✅    | Cluster link occurring on oso-clusterlink-demo topic from production to failover. |

# Basic RBAC Deployment
A minimum deployment using TLS encryption.  a LDAP container is also deployed which provides authorization.

## Features

| Feature          | Enabled | Note                     |
|:-----------------|:-------:|:-------------------------|
| Kafka/Zookeeper  |    ✅    |                          |
| Control Center   |    ✅    |                          |
| Connect          |    ❌    |                          |
| Schema Registry  |    ❌    |                          |
| KSQL             |    ❌    |                          |
| TLS Encryption   |    ✅    | Self-signed certificates |
| Authentication   |    ✅    |                          |
| Authorization    |    ✅    | via LDAP                 |

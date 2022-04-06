# Monitoring
This example show a typical monitoring configuration made up of Prometheus/Grafana for JMX metrics, and Logstash/Kibana for log handling. 

## Features

| Feature         | Enabled | Note                                |
|:----------------|:-------:|:------------------------------------|
| Kafka/Zookeeper |    ✅    |                                     |
| Control Center  |    ✅    |                                     |
| Connect         |    ❌    |                                     |
| Schema Registry |    ❌    |                                     |
| KSQL            |    ❌    |                                     |
| TLS Encryption  |    ✅    | Self-signed certificates            |
| Authentication  |    ✅    | RBAC                                |
| Authorization   |    ✅    | via LDAP and mTLS (inter-component) |
| Prometheus      |    ✅    |                                     |
| Grafana         |    ✅    |                                     |
| Logstash        |    ✅    |                                     |
| Kibana          |    ✅    |                                     |


## Kibana
Kibana has a UI you can view by forwarding port 5601 with the following command, and then accessing `http://127.0.0.1:5601` from a local browser.
```shell
kubectl port-forward \
$(kubectl get pods -n sandbox -l app=kibana -o name) \
5601 --namespace sandbox
```
## TODO - All working, but need to detail how to set up kibana (manual steps)
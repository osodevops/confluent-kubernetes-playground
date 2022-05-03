# Basic Deployment
This example deploys a basic deployment.  No RBAC/LDAP.  Just a single topic 'foobar' is added as part of the pipeline.


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


### Deploy CRDs
Deploy the CRDS using the standard way:
```shell
kubectl apply -k ../../base/crds
```
### Deploy Confluent Operator and Confluent Services
Deploy the confluent operator and services:
```shell
kubectl apply -k .
```

### Forward ports locally.
#### Source Kafka
Minikube:source:kafka:9071 -> localhost:9071
#### Source SchemaRegistry
Minikube:source:schemaregistry:9081 -> localhost:9081
#### Source Kafka
Minikube:destination:kafka:9071 -> localhost:9072
#### Source Kafka
Minikube:source:schemaregistry:9081 -> localhost:9082

```shell

kubectl port-forward kafka-0 9071:9071 --namespace source
```
kubectl port-forward \
$(kubectl get pods -n source -l statefulset.kubernetes.io/pod-name:kafka-0 -o name) \
:9071 -n source \ 
&& \
kubectl port-forward \
$(kubectl get pods -n source -l app.kubernetes.io/component=grafana -o name) \
:9071 -n source \
&& \
kubectl port-forward \
$(kubectl get pods -n source -l app.kubernetes.io/component=grafana -o name) \
9071 -n source
&& \
kubectl port-forward \
$(kubectl get pods -n source -l app.kubernetes.io/component=grafana -o name) \
9071 -n source

```

### Query schema Registry

[//]: # (TODO Port forward Production Schema Registry - 8081)
[//]: # (TODO Port forward Production Kafka Broker - 9092)

```
curl -k -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  --data '{"schema": "{\"type\": \"string\"}"}' \
   https://localhost:8081/subjects/im-a-source-schema/versions
```



```
curl -k -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
  --data '{"schema": "{\"type\": \"string\"}"}' \
   https://localhost:8082/subjects/im-a-desgination-schema/versions
```10.109.90.121

`curl -k -X GET https://10.109.90.121:8081/subjects`

`curl -k -X GET https://localhost:8082/subjects`

#TODO - how will 
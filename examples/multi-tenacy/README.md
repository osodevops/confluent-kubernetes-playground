# Multi tenancy Kafka (NICE!)
Todo.

### Deploy CRDs
Deploy the CRDS using the standard way:
```shell
kubectl apply -k ../../kustomize/crds
```

### Deploy Confluent Operator, Confluent Services, two namespaces with tenant topics
Deploy the confluent operator and services:
```shell
kubectl apply -k .
```
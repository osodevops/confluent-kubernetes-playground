# Schema CRD Deployment
A working example of the new Schema CRD, you can declaratively create, read, and delete schemas as Schema custom resources (CRs) in Kubernetes.

The example uses an Avro schema which is loaded into a ConfigMap and referenced in the Schema CRD. 

## Features

| Feature         | Enabled | Note   |
|:----------------|:-------:|-------:|
| Kafka/Zookeeper |    ✅    |        |
| Control Center  |    ✅    |        |
| Connect         |    ❌    |        |
| Schema Registry |    ✅    |        |
| KSQL            |    ❌    |        |
| TLS Encryption  |    ❌    |        |
| Authentication  |    ❌    |        |


### Output
CRD sample:
```shell
apiVersion: platform.confluent.io/v1beta1
kind: Schema
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"platform.confluent.io/v1beta1","kind":"Schema","metadata":{"annotations":{},"name":"customer-schema","namespace":"sandbox"},"spec":{"data":{"configRef":"oso-schema-config","format":"avro"}}}
    platform.confluent.io/config-revision-hash: 9kg4kgmch4
  creationTimestamp: "2022-05-03T16:48:42Z"
  finalizers:
  - schema.finalizers.platform.confluent.io
  generation: 1
  name: customer-schema
  namespace: sandbox
  ownerReferences:
  - apiVersion: platform.confluent.io/v1beta1
    blockOwnerDeletion: true
    controller: true
    kind: SchemaRegistry
    name: schemaregistry
    uid: a7714a0e-6e5d-4950-b3b0-8b5f427a78f7
  resourceVersion: "6627"
  uid: 2ccb3eb6-1581-4710-9ab4-834f6ffc1419
spec:
  data:
    configRef: oso-schema-config
    format: avro
status:
  conditions:
  - lastProbeTime: "2022-05-03T16:48:42Z"
    lastTransitionTime: "2022-05-03T16:48:42Z"
    message: Schema version create successful
    reason: successfully created schema version 1
    status: "False"
    type: platform.confluent.io/failed-create-version
  format: avro
  id: 3
  schemaRegistryEndpoint: https://schemaregistry.sandbox.svc.cluster.local:8081
  schemaRegistryTLS: true
  state: SUCCEEDED
  subject: customer-schema
  version: 1
```
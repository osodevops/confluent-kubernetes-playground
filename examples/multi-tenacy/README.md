# Multi tenancy Kafka (NICE!)
A multi tenant RBAC enabled production Confluent Platform install. This example showcases how large highly regulated enterprises can leverage CFK to securely deploy Kafka As A Service (KAAS)

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

### Using KafkaRestClass in multiple namespaces
KafkaRestClass is an abstraction that contains information about address and credentials to enable something to talk to a Kafka REST MDS endpoint. We can use this per tenant to authenticate different users in different namespaces.
- You can create default KafkaRestClass object with a user that has cluster access to create rolebindings / topics for Confluent Platform RBAC.
- You can configure multiple KafkaRestClass CRs to manage topics and role bindings across different Kafka clusters.
- Supports basic / bearer authentication methods
- TLS client configuration. Required when MDS is running in the HTTPS mode. (does not support MTLS)
- We can specify the endpoint if kafka cluster is in different namespace to Topic. Two options, directly inline in the Topic CRD or via secretRef which will contain credentials also

#### Notes
Currently working through these example:

- https://medium.com/@hiroyuki.osaki/illustration-open-policy-agent-aaf05bb0de8f
- https://elastisys.com/enforcing-policy-as-code-using-opa-and-gatekeeper-in-kubernetes/
- https://github.com/digiwhite1980/flux/tree/master/bases/open-policy-agent
- https://www.openpolicyagent.org/docs/latest/kubernetes-tutorial/



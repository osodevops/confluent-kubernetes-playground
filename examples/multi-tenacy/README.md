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


#### Notes
currently working through thsese example: 

- https://medium.com/@hiroyuki.osaki/illustration-open-policy-agent-aaf05bb0de8f
- https://elastisys.com/enforcing-policy-as-code-using-opa-and-gatekeeper-in-kubernetes/
- https://github.com/digiwhite1980/flux/tree/master/bases/open-policy-agent
- https://www.openpolicyagent.org/docs/latest/kubernetes-tutorial/



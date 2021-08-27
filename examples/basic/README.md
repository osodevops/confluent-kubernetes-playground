# Basic Deployment
This example deploys a basic deployment.  No RBAC/LDAP.  Just a single topic 'foobar' is added as part of the pipeline.
### Deploy CRDs
Deploy the CRDS using the standard way:
```shell
kubectl apply -k ../../kustomize/crds
```
### Deploy Confluent Operator and Confluent Services
Deploy the confluent operator and services:
```shell
kubectl apply -k .
```
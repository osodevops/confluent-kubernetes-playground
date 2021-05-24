# confluent-kubernetes-playground
## Overview
The examples found in this repository have been tested against a local minikube.

### Pre-requisites
* kubectl
* minikube

## Deploying an example
Before you can deploy any of the deployment examples found in `./examples`, we must first deploy some shared resources (an LDAP stub and Confluent-specific CRDs).  To deploy, from the root of this repository, run:

```
$ kubectl apply --kustomize ./infrastructure
```


### Examples
## custom-tls
`./examples/custom-tls`
An example of a deployment which is using custom TLS certificates.  See `./resources/certificates` for certificate generation tutorial/example.

```
$ kubectl apply --kustomize ./examples/custom-tls
```

## generated-tls
`./examples/generated-tls`
An example of a deployment which is uses the Confluent Operators built-in certifiate generation.

```
$ kubectl apply --kustomize ./examples/generated-tls
```
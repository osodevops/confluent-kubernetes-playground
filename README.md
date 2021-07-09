# Confluent for Kubernetes Playground
This repository contains Scenario workflows to deploy and manage Confluent on Kubernetes for various use cases.

## Overview
The examples found in this repository have been tested against a local minikube.

## Prerequisites
You will need a Kubernetes cluster version 1.16 or newer and kubectl version 1.18 running locally.
* kubectl
* [Minikube](https://minikube.sigs.k8s.io/docs/start/)

## Deploying an example
Before you can deploy any of the deployment examples found in `./examples`, we must first deploy the Confluent-specific CRDs.  To deploy, from the root of this repository, run:

```
$ kubectl apply --kustomize ./kustomize/crds
```

### Examples
## TODO
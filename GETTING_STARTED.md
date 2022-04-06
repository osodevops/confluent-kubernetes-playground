### Getting Started

#### Deploying the Operator

[//]: # (TODO: describe how this is a declarative adaptation of CFK's helm instructions.  Also discuss the update script that we have and how version numbers of the components are also important)
Before you can deploy any of the deployment examples found in `./stable` and `./incubator`, we must first deploy the CFK Operator, and it's dependent CRDs.  To deploy, from the root of this repository, run:
  ```shell
    kubectl apply --kustomize ./base/cfk-base/latest/crds && sleep 5 && kubectl apply --kustomize ./base/cfk-base/latest/templates
  ```
  We have taken the approach to deploy the Operator at a cluster-wide level, to allow use to experiment with multi-tenant configurations
  

### Deploying the example
Unless otherwise started in the README.md of each example, it should be assumed that we will deploy the example by running
  ```shell
  export EXAMPLE=base-rbac
  kubectl apply -kustomize ./stable/$EXAMPLE
  ```


### Tearing Down

[//]: # (TODO: Describe recomendation to teardown and redeploy other examples)
minikube delete && minikube start --memory 24576 --cpus 12

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




4. Using a tool like [K9s](https://github.com/derailed/k9s) check the status of the pods:
```shell
➜  replicator git:(replicator) ✗ kubectl get pods -A
NAMESPACE     NAME                                 READY   STATUS    RESTARTS   AGE
sandbox       confluent-operator-d4bb8cbd6-qg4dq   1/1     Running   0          14m
sandbox       console-producer-0                   1/1     Running   1          14m
sandbox       kafka-0                              1/1     Running   1          13m
sandbox       kafka-1                              1/1     Running   0          13m
sandbox       kafka-2                              1/1     Running   0          13m
sandbox       zookeeper-0                          1/1     Running   0          13m
sandbox       zookeeper-1                          1/1     Running   0          13m
sandbox       zookeeper-2                          1/1     Running   0          13m
tools         ldap                                 1/1     Running   1          14m
```


### Tearing Down

[//]: # (TODO: Describe recomendation to teardown and redeploy other examples)
minikube delete && minikube start --memory 24576 --cpus 12

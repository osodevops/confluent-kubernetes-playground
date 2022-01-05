# Replicator

In this scenario example, you'll deploy two Confluent clusters. One is the source cluster, and one is the destination cluster. You'll deploy Confluent Replicator on the destination cluster, where it will copy topic messages from the source cluster and write to the destination cluster.

1. Generate certificates for source and destination clusters. For this example we are going to include both in a single keystore / truststore. In a production environment these would be individual jks.
```shell
    cd resources/certificates
    ./generate_certificate.sh replicator-server-domiains.json
```

2. Navigate to the replicator directory where the rest of these commands will be run from:
```shell
cd examples/replicator
```

3. Deploy the CRDS using the standard way:
```shell
kubectl apply -k ../../kustomize/crds
```

3. Deploy the replicator which use Kustomize to pull in the base and example overlays using the following
```shell
kubectl apply -k .
```

4. Using a tool like [K9s](https://github.com/derailed/k9s) check the status of the pods:
```shell
➜  replicator git:(replicator) ✗ kubectl get pods -A
NAMESPACE     NAME                                 READY   STATUS    RESTARTS   AGE
destination   controlcenter-0                      1/1     Running   3          13m
destination   kafka-0                              1/1     Running   1          13m
destination   kafka-1                              1/1     Running   1          13m
destination   kafka-2                              1/1     Running   1          13m
destination   replicator-0                         1/1     Running   3          13m
destination   schemaregistry-0                     1/1     Running   6          13m
destination   zookeeper-0                          1/1     Running   0          13m
destination   zookeeper-1                          1/1     Running   0          13m
destination   zookeeper-2                          1/1     Running   0          13m
kube-system   coredns-74ff55c5b-44zs2              1/1     Running   0          172m
kube-system   etcd-minikube                        1/1     Running   0          172m
kube-system   kube-apiserver-minikube              1/1     Running   0          172m
kube-system   kube-controller-manager-minikube     1/1     Running   0          172m
kube-system   kube-proxy-fnjt5                     1/1     Running   0          172m
kube-system   kube-scheduler-minikube              1/1     Running   0          172m
kube-system   storage-provisioner                  1/1     Running   1          172m
sandbox       confluent-rbac-operator-d4bb8cbd6-qg4dq   1/1     Running   0          14m
sandbox       console-producer-0                   1/1     Running   1          14m
sandbox       kafka-0                              1/1     Running   1          13m
sandbox       kafka-1                              1/1     Running   0          13m
sandbox       kafka-2                              1/1     Running   0          13m
sandbox       zookeeper-0                          1/1     Running   0          13m
sandbox       zookeeper-1                          1/1     Running   0          13m
sandbox       zookeeper-2                          1/1     Running   0          13m
tools         ldap                                 1/1     Running   1          14m
```

5. Instantiate the Replicator Connector instance through the REST interface. You do this by using a JSON configuration file. `replicator.json` contains all the task configuration. To deploy the task simply run the following script:
```shell
./create_replication_job.sh
```

** NOTE: It may take sometime for the replicator-0 pod to become 'healthy' when running on a local minikube.

#### Check the status of the Replicator Connector instance
```
curl -u testadmin:testadmin -XGET -H "Content-Type: application/json" https://localhost:8083/connectors -k
curl -u testadmin:testadmin -XGET -H "Content-Type: application/json" https://localhost:8083/connectors/replicator/status -k
```

#### To delete the connector:

```
curl -u testadmin:testadmin -XDELETE -H "Content-Type: application/json" https://localhost:8083/connectors/replicator -k
```

### View in Control Center

To connect and view the control centre you will beed to port forward from the C3 pod using the command below. Log in using username: `test-admin` password `test-admin` click the replicators tab and you should see the job running.
```shell
kubectl port-forward controlcenter-0 9021:9021 --namespace destination
```

Open your browser and hit: [https://localhost:9021](https://localhost:9021)
### Validate that it works

Open Control center, select destination cluster, topic `${topic}_replica` where $topic is the name of the approved topic (whitelist).
You should start seeing messages flowing into the destination topic.


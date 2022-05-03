# Replicator

In this scenario example, you'll deploy two Confluent clusters. One is the source cluster, and one is the destination cluster. You'll deploy Confluent Replicator on the destination cluster, where it will copy topic messages from the source cluster and write to the destination cluster.


| Feature          | Enabled | Note                         |
|:-----------------|:-------:|:-----------------------------|
| Kafka/Zookeeper  |    ✅    |                              |
| Control Center   |    ✅    |                              |
| Connect          |    ✅    | Connector running replicator |
| Schema Registry  |    ❌    |                              |
| KSQL             |    ❌    |                              |
| TLS Encryption   |    ✅    | Self-signed certificates     |
| Authentication   |    ✅    | RBAC                         |
| Authorization    |    ✅    | via LDAP                     |



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


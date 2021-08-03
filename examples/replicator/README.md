# Replicator

In this scenario example, you'll deploy two Confluent clusters. One is the source cluster, and one is the destination cluster. You'll deploy Confluent Replicator on the destination cluster, where it will copy topic messages from the source cluster and write to the destination cluster.


## Validate replicator is working

### View in Control Center

Open Confluent Control Center. Port forward to your local machine using

```
kubectl port-forward -n destination controlcenter-0  9021:9021
```


```shell
cat <<EOF > adminclient.properties
security.protocol=SASL_SSL
sasl.mechanism=PLAIN 
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="kafka" password="kafka-secret";
ssl.truststore.location=/mnt/sslcerts/truststore.p12
ssl.truststore.type=PKCS12
ssl.truststore.password=mystorepassword
ssl.endpoint.identification.algorithm=
EOF
```
Log in using username: `test-admin` password `test-admin` click the replicators tab and you should see the job running.
1. Exception while setting up monitoring for replicator.
```shell
[ERROR] 2021-07-27 14:33:27,583 [main] org.apache.kafka.connect.cli.ConnectDistributed startConnect - Failed to start Connect                                                                                                                │
│ org.apache.kafka.connect.errors.ConnectException: Failed to find any class that implements interface org.apache.kafka.connect.rest.ConnectRestExtension and which name matches io.confluent-rbac.connect.replicator.monitoring.ReplicatorMonitori │
│     at org.apache.kafka.connect.runtime.isolation.Plugins.newPlugin(Plugins.java:441)                                                                                                                                                        │
│     at org.apache.kafka.connect.runtime.isolation.Plugins.newPlugins(Plugins.java:427)                                                                                                                                                       │
│     at org.apache.kafka.connect.runtime.rest.RestServer.registerRestExtensions(RestServer.java:452)                                                                                                                                          │
│     at org.apache.kafka.connect.runtime.rest.RestServer.initializeResources(RestServer.java:239)                                                                                                                                             │
│     at org.apache.kafka.connect.runtime.Connect.start(Connect.java:55)                                                                                                                                                                       │
│     at org.apache.kafka.connect.cli.ConnectDistributed.startConnect(ConnectDistributed.java:139)                                                                                                                                             │
│     at org.apache.kafka.connect.cli.ConnectDistributed.main(ConnectDistributed.java:79)
```
Fixed with:

      - name: CLASSPATH
        value: /usr/share/java/kafka-connect-replicator/replicator-rest-extension-7.0.0.jar
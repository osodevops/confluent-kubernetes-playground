# Confluent Replicator
## Overview
This example shows how 2 DCs can replicate a topic from a 'source'
(DC1) to a 'destination' (DC2) using [Confluent Replicator](https://docs.confluent.io/platform/current/multi-dc-deployments/replicator/index.html)

### Notes
We have reduced the broker and zookeeper to a single instance to accomodate local environments with 32GB or less (it was tending to crash systems).  Environments with ~64GB of memory should be able to run with a proper 3broker/3zookeeper solution.  Should you wish to do so, comment out the following in the DC1/DC2 kustomize file:

```
patchesStrategicMerge:
  - kafka.yaml
  - zookeeper.yaml
 ```

And the following overrides from the control-center.yamls
```
  configOverrides:
    server:
      - confluent.controlcenter.internal.topics.replication=1
      - confluent.controlcenter.command.topic.replication=1
      - confluent.monitoring.interceptor.topic.replication=1
      - confluent.metrics.topic.replication=1
  ```
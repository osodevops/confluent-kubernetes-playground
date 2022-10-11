# Runbook for Confluent Disaster Recovery at STCPay

#### Overview

## Confirmed assumptions:
Consumers are idempotent. - this is a requirement as replicator is asyncronus
We have zero abiilty to change how the producers/consumers are configured (beside endpoints)
Producers are acks=all
SchemaRegistry will not be updated during any failover/failback


## GOALS
RPO - Recovery Point Objective
As close as 0 as possible

RTO - Recovery Time Objective
Back as fast as possible, but stability is more important


Recovery method; timestamp based
#### Monitoring Metrics:

confluent-replicator-source-cluster
confluent-replicator-destination-cluster
confluent-replicator-destination-topic-name (many)
confluent-replicator-task-topic-partition-message-lag
confluent-replicator-task-topic-partition-byte-throughput
confluent-replicator-task-topic-partition-latency


#### Preparation:
Script to avoid new events on topics?  How?
Script to validate datacenter readyness? - verify consumer lag = 0, then reset all consumesr to log end offset
Certificates safely stored? (na?)
CI/CD Pipelines (already done?)
Migration scirpts (TBD)
Runbook (this document)
Check dataloss/offset reset
Monitoring (what do we have?)

#### Failover:
* stop producers/consumers
* adjust producers/consumers to point to DR (SR and Brokers)
* What will this mean for the connect workers?
* Are any Databases (CDC?) also needing updating?
* Deny access to DC (if possible)
* rollout producers/consumers

#### Failback
* Scripts to check for dataloss (??)
* Replicate topics to DC1

#### Problems to solve
We are not using interceptor to worry with timestamps (as consumers are indempotent), however, I suspect this will be requried if DR is to be 'long lived'

#### How to replicate?
* how do we replicate an outage?  
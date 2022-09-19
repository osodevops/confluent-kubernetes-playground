# Implementation of Confluent Replicator to STCPay

#### Overview
This document sets out to detail how STCPay has implemented [Confluent Replicator](https://docs.confluent.io/platform/current/multi-dc-deployments/replicator/index.html) as a solution for Disaster Recovery between the main data center located in ___________ (dc1) and the 'fail-over' data center located in __________ (dc2).

Confluent Replicator is deployed into the DR data center as a connect job run on its own dedicated connect cluster, often referred to as a 'replication' cluster as it uses an image that is bepoke for the replication task.  After successfully configuration, the connect job is configured to 'replicate' topics from the 'source' cluster (dc1), to the 'destination' cluster (dc2).  During this time, any schemas associated with the topics, are also replicated over, and assoicated to the topics accordingly.

New topics created in the 'source' cluster will automatically be detectd and replicated to the 'destination' cluster.

#### In the event of a fail-over test
Should a disaster event occur to DC1 causing it to fail all producers and consumers would 'fail-over' to DC2 (meaning, producers are now writing there, and consumers are consuming there).  When DC1 is ready to come back online, any new messages which were written during the time of this fail-over will need to be replicated back to DC1 before it may come online

#### Performing a fail-over test (steps)
* Kill DC1

QUESTIONS???

* `Are the consumers using an auto.offset.reset of earliest or latest??
* Verify CA in prod is the same as QA
* Change dev user to prod, and add rolebinding to PROD. - do this by Monday...
* In contrast, in active-passive designs, it is simplest to not allow producers to send new messages to the Disaster Recovery for Multi-Datacenter Apache Kafka® Deployments
backup datacenter while the primary is down. -- possible??  Do the producers have an acks=all presumably?
* If DC1 is corrupted, we need a fall back restore (replicator from DC2?)

Next, use Replicator to copy existing data in DC-2 to restore DC-1. Recall that the backup cluster, DC-2,
may have a mix of data:
• Data that was originally produced to DC-1 before the disaster event, replicated with added
provenance information in message headers
• Data that was originally produced to D
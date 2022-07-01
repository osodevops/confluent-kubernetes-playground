# Basic Deployment
This example deploys Chaos Mesh.

[//]: # (TODO) Explain more on chaos Mesh

## Deployment Instructions
### Deploy CFK
From within this present directory(./examples/grafana-prometheus), run the following command:

```shell
kubectl apply -k ../../kustomize/crds
kubectl apply -k ./environments
```

### Deploy Chaos Mesh 
From the directory, run the following
```shell
kubectl create -k ./chaos-mesh/crds
kubectl apply -k ./chaos-mesh/templates
```
NOTE: 
* kubectl 'apply' for the above will fail for the CRDS.
* These YAML definitions were obtained by running `helm template chaos-mesh/chaos-mesh --version 2.2.0 --set dashboard.securityMode=false --set dnsServer.create=true --include-crds --output-dir .`  The lack of dashboard security was required because we ran into this bug: https://github.com/chaos-mesh/chaos-mesh/issues/3326

Once the pod named 'chaos-dashboard-RANDOMNUMBER' is up and running, you can port forward port 2333 to your local machine and access the Chaos Mesh Dashboard


### Deploy Chaos Tests 
```shell
kubectl apply -k ./experiments
```

## Test Behaviours/Expectations
### DNS Tests
NOTE: this requires the DNSChaos feature in the Helm chart to be enabled (disabled by default)

An random pattern to master names space on the DNS entry zookeeper.dogs.svc.cluster.local does not seem to affect the ability of kafka broker on master to resolve the DNS


java.lang.IllegalArgumentException: Unable to canonicalize address zookeeper.dogs.svc.cluster.local:2181 because it's not resolvable

Failure: 
Failed to apply chaos: Service "chaos-mesh-dns-server" not found
### IO Tests
### JVM Tests
#### JVMChaos:exception
Target: Kafka
Logs
```
"kafka-scheduler-4" #46 daemon prio=5 os_prio=0 cpu=211.35ms elapsed=1222.00s tid=0x00007fc032e8f000 nid=0x4c waiting on condition  [0x00007fbfad32e000]
   java.lang.Thread.State: WAITING (parking)
 ```

### Network Tests

##### NetworkChaos: Corrupt
Component: Kafka
Observed Behaviour:
* Kafka Log: [AdminClient clientId=_confluent_balancer_api_state-admin-0] Node 2 disconnected.  


#### IO Tests
### Pod Fault Tests
Kill all Zookeeper - 
##### StressChaos: CPU
Component: Kafka
Observed Behaviour:
`Failed to apply chaos: rpc error: code = Unknown desc = Error loading cgroup v2 manager: cgroups: invalid group path`

Ran JVM exception - it threw a bunch of errors into Kafka pods, but showing as `Failed to apply chaos: rpc error: code = Unknown desc = com.sun.tools.attach.AttachNotSupportedException` in Chaos mesh

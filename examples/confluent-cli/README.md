# Using Confluent CLI with CFK
This example deploys a basic deployment.  No RBAC/LDAP.  Just a single topic 'foobar' is added as part of the pipeline.

### Deploy CRDs
Deploy the CRDS using the standard way:
```shell
cd examples/confluent-cli
kubectl apply -k ../../kustomize/crds
```

### Deploy Confluent Operator and Confluent Services
Deploy the confluent operator and services:
```shell
kubectl apply -k .
```

### Using the proxy without MDS
You need to run the following commands:
```shell
$ kubectl port-forward -n tools proxy 9100:9100

export HTTPS_PROXY=socks5://127.0.0.1:9100

KAFKA_ID=$(curl -x socks5h://127.0.0.1:9100 -ks https://kafka.sandbox.svc.cluster.local:8090/v1/metadata/id | jq -r '.scope.clusters["kafka-cluster"]')

CONFLUENT_USERNAME=kafka \
CONFLUENT_PASSWORD=kafka-secret \
confluent login

```

### Using the proxy with MDS / RBAC
You will need to run some extra commands:
```shell
export HTTPS_PROXY=socks5://127.0.0.1:9100

KAFKA_ID=$(curl -x socks5h://127.0.0.1:9100 -ks https://kafka.sandbox.svc.cluster.local:8090/v1/metadata/id | jq -r '.scope.clusters["kafka-cluster"]')

CONFLUENT_USERNAME=kafka \
CONFLUENT_PASSWORD=kafka-secret \
CONFLUENT_MDS_URL=https://kafka.sandbox.svc.cluster.local:8090 \
CONFLUENT_CA_CERT_PATH=../certificates/rootca.pem \ #pull from tls-group1 secret 
confluent login
```
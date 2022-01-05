# User Provider mTLS

In this scenario example, you'll deploy the Confluent platform each with its own certificate to validate the architecture and deployment. The certificates that are generated in this example use the `sandbox` namespace. **NOTE** You will need to change this for your environment which is why the generate_certificates.sh script is used.

1. Create one server certificate per Confluent component service. You'll use the same certificate authority for all. Update `zookeeper-server-domain.json` and `kafka-server-domain.json` with your namespace and generate certificates for each component.  

```shell
    cd examples/userprovided-mtls
    ./generate_certificates.sh
```

2. Deploy the CRDS using the standard way:
```shell
kubectl apply -k ../../kustomize/crds
```

3. Deploy the mTLS example which use Kustomize to pull in the base and example overlays using the following
```shell
kubectl apply -k .
```

4. Validate zookeeper is working using:
```shell
kubectl logs -f -n sandbox zookeeper-0

[INFO] 2021-08-17 14:40:54,836 [QuorumPeer[myid=0](plain=0.0.0.0:2181)(secure=0.0.0.0:2182)] org.apache.zookeeper.server.ZooKeeperServer logEnv - Server environment:java.library.path=/usr/java/packages/lib:/usr/lib64:/lib64:/lib:/usr/lib
[INFO] 2021-08-17 14:40:54,836 [QuorumPeer[myid=0](plain=0.0.0.0:2181)(secure=0.0.0.0:2182)] org.apache.zookeeper.server.ZooKeeperServer logEnv - Server environment:java.io.tmpdir=/tmp
[INFO] 2021-08-17 14:40:54,836 [QuorumPeer[myid=0](plain=0.0.0.0:2181)(secure=0.0.0.0:2182)] org.apache.zookeeper.server.ZooKeeperServer logEnv - Server environment:java.compiler=<NA>
[INFO] 2021-08-17 14:40:54,836 [QuorumPeer[myid=0](plain=0.0.0.0:2181)(secure=0.0.0.0:2182)] org.apache.zookeeper.server.ZooKeeperServer logEnv - Server environment:os.name=Linux
[INFO] 2021-08-17 14:40:54,836 [QuorumPeer[myid=0](plain=0.0.0.0:2181)(secure=0.0.0.0:2182)] org.apache.zookeeper.server.ZooKeeperServer logEnv - Server environment:os.arch=amd64
[INFO] 2021-08-17 14:40:54,836 [QuorumPeer[myid=0](plain=0.0.0.0:2181)(secure=0.0.0.0:2182)] org.apache.zookeeper.server.ZooKeeperServer logEnv - Server environment:os.version=5.10.47-linuxkit
[INFO] 2021-08-17 14:40:54,836 [QuorumPeer[myid=0](plain=0.0.0.0:2181)(secure=0.0.0.0:2182)] org.apache.zookeeper.server.ZooKeeperServer logEnv - Server environment:user.name=?
[INFO] 2021-08-17 14:40:54,836 [QuorumPeer[myid=0](plain=0.0.0.0:2181)(secure=0.0.0.0:2182)] org.apache.zookeeper.server.ZooKeeperServer logEnv - Server environment:user.home=?
[INFO] 2021-08-17 14:40:54,836 [QuorumPeer[myid=0](plain=0.0.0.0:2181)(secure=0.0.0.0:2182)] org.apache.zookeeper.server.ZooKeeperServer logEnv - Server environment:user.dir=/opt
[INFO] 2021-08-17 14:40:54,836 [QuorumPeer[myid=0](plain=0.0.0.0:2181)(secure=0.0.0.0:2182)] org.apache.zookeeper.server.ZooKeeperServer logEnv - Server environment:os.memory.free=336MB
[INFO] 2021-08-17 14:40:54,836 [QuorumPeer[myid=0](plain=0.0.0.0:2181)(secure=0.0.0.0:2182)] org.apache.zookeeper.server.ZooKeeperServer logEnv - Server environment:os.memory.max=4096MB
[INFO] 2021-08-17 14:40:54,836 [QuorumPeer[myid=0](plain=0.0.0.0:2181)(secure=0.0.0.0:2182)] org.apache.zookeeper.server.ZooKeeperServer logEnv - Server environment:os.memory.total=357MB
[INFO] 2021-08-17 14:40:54,838 [QuorumPeer[myid=0](plain=0.0.0.0:2181)(secure=0.0.0.0:2182)] org.apache.zookeeper.server.ZooKeeperServer setMinSessionTimeout - minSessionTimeout set to 6000
[INFO] 2021-08-17 14:40:54,838 [QuorumPeer[myid=0](plain=0.0.0.0:2181)(secure=0.0.0.0:2182)] org.apache.zookeeper.server.ZooKeeperServer setMaxSessionTimeout - maxSessionTimeout set to 60000
[INFO] 2021-08-17 14:40:54,839 [QuorumPeer[myid=0](plain=0.0.0.0:2181)(secure=0.0.0.0:2182)] org.apache.zookeeper.server.ZooKeeperServer <init> - Created server with tickTime 3000 minSessionTimeout 6000 maxSessionTimeout 60000 datadir /mnt/data/txnlog/version-2 snapdir /mnt/data/data/version-2
[INFO] 2021-08-17 14:40:54,839 [QuorumPeer[myid=0](plain=0.0.0.0:2181)(secure=0.0.0.0:2182)] org.apache.zookeeper.server.quorum.Learner followLeader - FOLLOWING - LEADER ELECTION TOOK - 13 MS
[WARN] 2021-08-17 14:40:54,841 [QuorumPeer[myid=0](plain=0.0.0.0:2181)(secure=0.0.0.0:2182)] org.apache.zookeeper.server.quorum.Learner connectToLeader - Unexpected exception, tries=0, remaining init limit=30000, connecting to zookeeper-1.zookeeper.sandbox.svc.cluster.local/172.17.0.6:2888

[INFO] 2021-08-17 14:49:42,057 [nioEventLoopGroup-7-1] org.apache.zookeeper.server.auth.X509AuthenticationProvider handleAuthentication - Authenticated Id 'CN=kafka,L=Earth,ST=Pangea,C=Universe' for Scheme 'x509'
```

5. Validate Kafka is working using:
```shell
kubectl logs -f -n sandbox kafka-0

[INFO] 2021-08-17 14:49:00,492 [LicenseBackgroundFetcher RUNNING] org.apache.kafka.common.utils.AppInfoParser <init> - Kafka version: 6.1.2-ce
[INFO] 2021-08-17 14:49:00,493 [LicenseBackgroundFetcher RUNNING] org.apache.kafka.common.utils.AppInfoParser <init> - Kafka commitId: 4c988093cc81349d
[INFO] 2021-08-17 14:49:00,493 [LicenseBackgroundFetcher RUNNING] org.apache.kafka.common.utils.AppInfoParser <init> - Kafka startTimeMs: 1629211740492
[INFO] 2021-08-17 14:49:00,493 [kafka-producer-network-thread | confluent-rbac-metrics-reporter] org.apache.kafka.clients.Metadata update - [Producer clientId=confluent-rbac-metrics-reporter] Cluster ID: xBPcfVfKSrCS15AmzC6BUQ
```
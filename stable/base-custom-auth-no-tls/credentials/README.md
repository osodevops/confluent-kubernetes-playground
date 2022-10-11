# basic.txt
Credentials for control center users

Adding the following block to the Control Center YAML
```
authentication:
  type: basic
  basic:
    secretRef: credential
```
Will add the following config to controlcenter.properties:
```
confluent.controlcenter.auth.restricted.roles=Restricted
confluent.controlcenter.auth.session.expiration.ms=600000
confluent.controlcenter.rest.authentication.method=BASIC
confluent.controlcenter.rest.authentication.realm=c3
confluent.controlcenter.rest.authentication.roles=Administrators,Restricted
```
and the following to jvm.config
```
-Djava.security.auth.login.config=/mnt/config/shared/jaas-config.file
```
/mnt/config/shared/jaas-config.file: 
```
c3 {
   org.eclipse.jetty.jaas.spi.PropertyFileLoginModule required
   debug="false"
   refreshInterval="30"
   hotReload="true"
   file="/mnt/secrets/credential/basic.txt";
};
```

In this example, the contents of the file 'basic.txt' looks like this:
```
admin: Developer1,Administrators
admin1: Developer1,Administrators
```
This means, that if you were to go to C3, you could log in with the username of 'admin', and the password of 'Developer1'.  This user would have 'Administrator' rights

# plain.txt 
Credentials for clients to connect to kafka (SASL user)

## C3

```
kafka:
  bootstrapEndpoint: kafka:9071
  authentication:
    type: plain
    jaasConfig:
      secretRef: credential
```

Will change the C3 controlcenter.properties file from:
```
confluent.controlcenter.streams.security.protocol=PLAINTEXT
```
to

```
confluent.controlcenter.streams.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="${file:/mnt/secrets/credential/plain.txt:username}" password="${file:/mnt/secrets/credential/plain.txt:password}";
confluent.controlcenter.streams.sasl.mechanism=PLAIN
confluent.controlcenter.streams.security.protocol=SASL_PLAINTEXT
```


## Kafka 

```
  listeners:
    internal:
      authentication:
        type: plain
        jaasConfig:
          secretRef: credential
```

The following config will be added to `kafka.properties`
```
listener.name.internal.plain.sasl.jaas.config=io.confluent.kafka.server.plugins.auth.FileBasedLoginModule required config_path="/mnt/secrets/kafka-internal-listener-apikeys/apikeys.json" refresh_ms="3000";
listener.name.internal.sasl.enabled.mechanisms=PLAIN
listener.name.internal.sasl.mechanism=PLAIN
listener.name.replication.plain.sasl.jaas.config=io.confluent.kafka.server.plugins.auth.FileBasedLoginModule required username="${file:/mnt/secrets/kafka-internal-listener-apikeys/plain.txt:username}" password="${file:/mnt/secrets/kafka-internal-listener-apikeys/plain.txt:password}" config_path="/mnt/secrets/kafka-internal-listener-apikeys/apikeys.json" refresh_ms="3000";
listener.name.replication.sasl.enabled.mechanisms=PLAIN
listener.name.replication.sasl.mechanism=PLAIN
listener.security.protocol.map=EXTERNAL:PLAINTEXT,INTERNAL:SASL_PLAINTEXT,REPLICATION:SASL_PLAINTEXT
```

/mnt/secrets/kafka-internal-listener-apikeys/apikeys.json is derived from plain-users.json within the credential secret
```
{
  "keys": {
    "c3": {
      "sasl_mechanism": "PLAIN",
      "hashed_secret": "c3-secret",
      "hash_function": "none",
      "logical_cluster_id": "sandbox",
      "user_id": "c3",
      "service_account": false
    },
    "kafka": {
      "sasl_mechanism": "PLAIN",
      "hashed_secret": "kafka-secret",
      "hash_function": "none",
      "logical_cluster_id": "sandbox",
      "user_id": "kafka",
      "service_account": false
    },
    "kafka_client": {
      "sasl_mechanism": "PLAIN",
      "hashed_secret": "kafka_client-secret",
      "hash_function": "none",
      "logical_cluster_id": "sandbox",
      "user_id": "kafka_client",
      "service_account": false
    },
    "operator": {
      "sasl_mechanism": "PLAIN",
      "hashed_secret": "operator-secret",
      "hash_function": "none",
      "logical_cluster_id": "sandbox",
      "user_id": "operator",
      "service_account": false
    }
  }
}
```

/mnt/secrets/kafka-internal-listener-apikeys/plain.txt
```
username=operator
password=operator-secret
```

# digest.txt
Credential for kafka to connect to Zookeeper

Adding the YAML:
```
(kafka)
dependencies:
    zookeeper:
      endpoint: zookeeper:2181
      authentication:
        type: digest
        jaasConfig:
          secretRef: credential
```

Will add the line `-Djava.security.auth.login.config=/mnt/secrets/digest-jaas.conf` to jvm.config on Kafka.  The contents of this file will look like this:
```
Client {
  org.apache.zookeeper.server.auth.DigestLoginModule required
  username="alice"
  password="alice-secret";
};

```

# digest-users.json
A configuration for Zookeeper which permits kafka to connect to zookeeper

Adding the YAML:
``` 
(zookeeper)
  authentication:
    type: digest
    jaasConfig:
      secretRef: credential
``` 

Will add the line `-Djava.security.auth.login.config=/mnt/secrets/digest-jaas.conf ` to jvm.config on Zookeeper.  The contents of this file will look like this:
```
Server {
       org.apache.zookeeper.server.auth.DigestLoginModule required
       user_alice="alice-secret";
};

QuorumServer {
             org.apache.zookeeper.server.auth.DigestLoginModule required
             user_zookeeper="zookeeper-secret";
};

QuorumLearner {
              org.apache.zookeeper.server.auth.DigestLoginModule required
              username="zookeeper"
              password="zookeeper-secret";
```



# plain-users.json
As discussed in the plain.txt section, the plain-users.json file is used to create /mnt/secrets/kafka-internal-listener-apikeys/apikeys.json on the Kafka Broker.  This is effectively a dictionary of username/passwords

Credentials (multiple) for clients who are allowed to connect to kafka
```
{
  "kafka_client": "kafka_client-secret",
  "c3": "c3-secret",
  "kafka": "kafka-secret"
}
```
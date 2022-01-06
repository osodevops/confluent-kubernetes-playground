#!/bin/bash
kubectl config set-context --current --namespace=sandbox
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
helm install vault hashicorp/vault --set "server.dev.enabled=true"
sleep 5
while [[ $(kubectl get pods vault-0 -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]];
do echo "waiting for vault pod to be ready" && sleep 3;
done

kubectl exec -it vault-0 -- \
vault secrets enable -path=oso-confluent kv-v2

kubectl exec -it vault-0 -- \
vault auth enable kubernetes

kubectl exec -it vault-0 -- \
vault kv put oso-confluent/client/kafka-jaas jaas="
Client {
org.apache.zookeeper.server.auth.DigestLoginModule required
username="kafka"
password="kafka-secret";
};"

kubectl exec -it vault-0 -- \
vault kv put oso-confluent/client/zookeeper-jaas jaas="
Server {
    org.apache.zookeeper.server.auth.DigestLoginModule required
    user_kafka=\"kafka-secret\";
};

QuorumServer {
    org.apache.zookeeper.server.auth.DigestLoginModule required
    user_zookeeper=\"zookeeper-secret\";
};

QuorumLearner {
    org.apache.zookeeper.server.auth.DigestLoginModule required
    username=\"zookeeper\"
    password=\"zookeeper-secret\";
};"

kubectl exec -it vault-0 -- \
vault kv put oso-confluent/client/c3-jaas jaas="TBD"

kubectl exec -it vault-0 -- \
vault kv put oso-confluent/client/creds-kafka-zookeeper-credentials username="kafka" password="kafka-secret"
kubectl exec -it vault-0 -- \
vault kv put oso-confluent/client/ldap username="cn=mds,dc=test,dc=com" password="Developer!"
kubectl exec -it vault-0 -- \
vault kv put oso-confluent/client/plain-jaas string="org.apache.kafka.common.security.plain.PlainLoginModule required username=\"kafka\" password=\"kafka-secret\";"
kubectl exec -it vault-0 -- \
vault kv put oso-confluent/client/bearer username="kafka" password="kafka-secret"
kubectl exec -it vault-0 -- \
vault kv put oso-confluent/client/mds-token token="-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAwMyjnP4qfdTKhCS5sPbVqiXVyQ15wreVAsEqEsnMFt2JtML1
3ELOQ2szWn57Wzu782byEtYFlF3ToVW3cl4dOJRzaSEQ6xe10R/i7TneItEQfpJr
/2L4bubuQRGNe/KrLME0ivr9u4IEbbRS+ltu6A9ggzGcaDSxV/eyKMNPadHQ/AN4
BZijAeKZcDTjz6bHjJ6EQ3YNgqyn846reQk9ToHZl8bGHOhz5C7yoIfsxZgYHlnx
6JGsiUZ5P36WGc38ZIB/m45o8cv4ifUVPUB0IQQ9AhYI5ZuMrxDsRPDX2GG6E5bW
2vqDWyqXOY7cSoI7AikFdwATW4Rv7euEJUyzNwIDAQABAoIBAQCKzIhZhI14q1Hk
kj/wy7ME3FotdPscmGe5ZPDyN78rEvCJZvXzTVELLkj5NCeAhd+ImqtZriS0LFwo
QPphZqnoys7Pd5OjfB1T4X3QRSHLtPEH/kerw0eRJ8WMqKNQAWMERE+cYpd6f17K
z9ARFvQgMrnLmVK9nnmyF8t2Fy27wqUVBmYXX/m+ne/+2S4PO8ZsPd3wY2Y9R8LV
ufbHC+H2ExA8nE4ztefg9zPyn1wMi/GMUg1WiCT3B2u3CZsWaZJzVItT6t7qnAZJ
XzkgNpIHn9mWuwh8kxgMd6sxDRAOD5iPd6a9i0oLSaS3/0LDezULC0VhTPy3G2oR
A0AJeOnRAoGBAPV1uz1pPJAtemr8wLiKhQOe8jAsxtnSzV8Fqd11qJYgnihwai+Y
k44hOJ/02/6wyq49FhMGmkyFWv5dUDERGV7McXP6bEfY5c1P+PdRUAm5H5nef37z
NR9f7oifV3j+49uy2VfUQCr/h+T+ywzAoc0iZyYGaI1wjKXQr3+1o55vAoGBAMkU
Bq2IaIDwomBgQCKQjCy/ANjQ32yMAGHf/mE32RTFpu5SZELe9yrGQr3xHFtQ9aQL
Vv5P09wZfb4IOdp/3wwHMqFjNjNdG8sw7RyNS+wfQGu8v1GfYssuBuXi9v0XGXFH
WenNQEUPbibRbocJ92OJTJK4P/s5vv132HDR/pu5AoGBAJ+Y8Sm45zwHlfVCajyT
NHFqQ6a3NoQi4I3MLOplujwC8VLx5NkVp7teNmcq2m/7m403AsdUH7dpbgS9v4pn
x8svuwTh6s28ZY7dVM/Z+uSXjciKNvPgRsYjpgEHOeTeNmF/JHpK834Br+ZhFL0x
8wJiQBclS43LhGe8DKBJBh3ZAoGAN5bHudXKPktIOKijUmrvtbcgPtCP0+xodqZ8
JthPtURnP9+bRDlrz3F8JhKwKjaZkj5oUGo1QdXyQ0T26YcMXMDoqGFLLKwC8QuX
oZsWcDK7lo1ZvvD3WQBie89hRNrL99sn6lEKAY2ggC7KBZ8lu2jLuIwjdAqk2GH3
fkkvwFECgYAyXj5z6COPIDJ1E1VLrJiw1YBXaa7ZLk5Epw3QvCM7hTKSFbuSNwsp
EuLmM7g8wMPZAbzs/RQOaf9IhE/x53dO2Imk5PARaoEsSFjND4dpVHaKem2cBomt
x5q0SqUVq6xv42213glBQMDJ4qQXTrsEBdpNynv7oVeXXwcaOTUaBw==
-----END RSA PRIVATE KEY-----"

kubectl exec -it vault-0 -- \
vault kv put oso-confluent/client/mds-key key="-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwMyjnP4qfdTKhCS5sPbV
qiXVyQ15wreVAsEqEsnMFt2JtML13ELOQ2szWn57Wzu782byEtYFlF3ToVW3cl4d
OJRzaSEQ6xe10R/i7TneItEQfpJr/2L4bubuQRGNe/KrLME0ivr9u4IEbbRS+ltu
6A9ggzGcaDSxV/eyKMNPadHQ/AN4BZijAeKZcDTjz6bHjJ6EQ3YNgqyn846reQk9
ToHZl8bGHOhz5C7yoIfsxZgYHlnx6JGsiUZ5P36WGc38ZIB/m45o8cv4ifUVPUB0
IQQ9AhYI5ZuMrxDsRPDX2GG6E5bW2vqDWyqXOY7cSoI7AikFdwATW4Rv7euEJUyz
NwIDAQAB
-----END PUBLIC KEY-----"

# do this for every user/secret
kubectl exec -it vault-0 -- \
vault kv put oso-confluent/client/mds-client-c3 username="c3" password="c3-secret"

kubectl exec -i vault-0 -- \
vault policy write oso-confluent-vault-policy - <<EOF
path "oso-confluent/data/client/kafka-jaas" {
  capabilities = ["read"]
}
path "oso-confluent/data/client/zookeeper-jaas" {
  capabilities = ["read"]
}
path "oso-confluent/data/client/c3-jaas" {
  capabilities = ["read"]
}
path "oso-confluent/data/client/mds-client-c3" {
  capabilities = ["read"]
}
path "oso-confluent/data/client/creds-kafka-zookeeper-credentials" {
  capabilities = ["read"]
}
path "oso-confluent/data/client/ldap" {
  capabilities = ["read"]
}
path "oso-confluent/data/client/plain-jaas" {
  capabilities = ["read"]
}
path "oso-confluent/data/client/bearer" {
  capabilities = ["read"]
}
path "oso-confluent/data/client/mds-token" {
  capabilities = ["read"]
}
path "oso-confluent/data/client/mds-key" {
  capabilities = ["read"]
}
EOF

kubectl exec -i vault-0 -- \
vault write auth/kubernetes/role/oso-confluent-vault-role \
bound_service_account_names=oso-confluent-vault-account \
bound_service_account_namespaces=sandbox \
policies=oso-confluent-vault-policy \
ttl=24h




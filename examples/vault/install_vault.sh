#!/bin/bash

kubectl config set-context --current --namespace=sandbox
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
# Development mode: Running a Vault server in development is automatically initialized and unsealed. This is ideal in a learning environment but NOT recommended for a production environment.
helm install vault hashicorp/vault --set "server.dev.enabled=true"
## wait for valut-0
while [[ $(kubectl get pods vault-0 -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]];
do echo "waiting for pod" && sleep 1;
done
kubectl exec -it vault-0 -- \
vault secrets enable -path=internal kv-v2
kubectl exec -it vault-0 -- \
vault auth enable kubernetes
#TODO: this seems to error when run from command all in one, OK when on container.
kubectl exec -it vault-0 -- \
vault write auth/kubernetes/config \
    token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
    kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
    kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
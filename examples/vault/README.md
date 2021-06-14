# Demo: Confluent for Kubernetes with Vault integration

## Overview
This demo exhibits how we can integrate Hashicorp Vault into the confluent for kubernetes deployment.  This demo implements vault in 'developer mode', this is not a production solution.    

### How to deploy Confluent-for-Kuberentes with Vault integration
###### Commands To be run from ./examples/vault 
* Deploy Infrastructure
  `kubectl apply -k ../../kustomize/infrastructure`
* Provision Vault
  `./vault_c3.sh`
* Authenticate Vault using a Kubernetes token
    * Exec onto vault container:
        `kubectl exec -it vault-0 -- sh`
    * Write vault config:
      ```
      vault write auth/kubernetes/config \
      token_reviewer_jwt=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token) \
      kubernetes_host=https://$KUBERNETES_PORT_443_TCP_ADDR:$KUBERNETES_PORT_443_TCP_PORT \
      kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
      ```
* Deploy confluent
  `kubectl apply -k .`
  
#!/bin/bash
#kubectl config set-context --current --namespace=sandbox
#helm repo add hashicorp https://helm.releases.hashicorp.com
#helm repo update
#helm install vault hashicorp/vault --set "server.dev.enabled=true"
#sleep 5
#while [[ $(kubectl get pods vault-0 -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]];
#do echo "waiting for vault pod to be ready" && sleep 3;
#done
#
## enable the pki engine as this is not enabled by default
#kubectl exec -it vault-0 -- \
#vault secrets enable -path=pki_root_ca pki
#
## tune the ttl on certificates for demo purpose
#kubectl exec -it vault-0 -- \
#vault secrets tune -max-lease-ttl=10m pki_root_ca

# provide root signing certificate and private key.
#pem=$(cat ./certificates/ca.crt >> ./certificates/ca.key)
pem=$(cat "./certificates/ca.pem")
echo $pem
echo "    Creating Root CA"
kubectl exec -it vault-0 -- \
vault write pki_root_ca/config/ca pem_bundle=$pem

# update the CRL location and issuing certificates.
#vault write pki/config/urls \
#    issuing_certificates="http://127.0.0.1:8200/v1/pki/ca" \
#    crl_distribution_points="http://127.0.0.1:8200/v1/pki/crl"
#!/bin/bash
kubectl config set-context --current --namespace=sandbox
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
helm install vault hashicorp/vault --set "server.dev.enabled=true"
sleep 5
while [[ $(kubectl get pods vault-0 -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]];
do echo "waiting for vault pod to be ready" && sleep 3;
done

#enable Vault PKI secret engine
kubectl exec -it vault-0 -- \
vault secrets enable pki

kubectl exec -it vault-0 -- \
vault auth enable kubernetes

#set default ttl
kubectl exec -it vault-0 -- \
vault secrets tune -max-lease-ttl=87600h pki

#generate (temporary) root CA
kubectl exec -it vault-0 -- \
vault write -format=json pki/root/generate/internal \
common_name="svc.cluster.local" ttl=8760h  > pki-ca-root.json

#save the certificate in a sepearate file, we will add it later as trusted to our browser/computer (?)
cat pki-ca-root.json | jq -r .data.certificate > ca.pem

#publish urls for the root ca
kubectl exec -it vault-0 -- \
vault write pki/config/urls \
        issuing_certificates="http://127.0.0.1:8200/v1/pki/ca" \
        crl_distribution_points="http://127.0.0.1:8200/v1/pki/crl"

#enable pki secret engine for intermediate CA
kubectl exec -it vault-0 -- \
vault secrets enable -path=pki_int pki

#set default ttl
kubectl exec -it vault-0 -- \
vault secrets tune -max-lease-ttl=43800h pki_int

echo "sleeping for 3 seconds"
sleep 3

#create intermediate CA with common name example.com and
#save the CSR (Certificate Signing Request) in a seperate file
kubectl exec -it vault-0 -- \
vault write -format=json pki_int/intermediate/generate/internal \
        common_name="sandbox.svc.cluster.local Intermediate Authority" \
        | jq -r '.data.csr' > pki_intermediate.csr



#send the intermediate CA's CSR to the root CA for signing
#save the generated certificate in a sepearate file
export PKICERT=$(cat pki_intermediate.csr)
kubectl exec -it vault-0 -- \
vault write -format=json pki/root/sign-intermediate csr="$PKICERT" \
        format=pem_bundle ttl="43800h" \
        | jq -r '.data.certificate' > intermediate.cert.pem


#publish the signed certificate back to the Intermediate CA
export INTERMEDIATECERT=$(cat intermediate.cert.pem)
kubectl exec -it vault-0 -- \
vault write pki_int/intermediate/set-signed certificate="$INTERMEDIATECERT"

#publish the intermediate CA urls
kubectl exec -it vault-0 -- \
vault write pki_int/config/urls \
     issuing_certificates="http://127.0.0.1:8200/v1/pki_int/ca" \
     crl_distribution_points="http://127.0.0.1:8200/v1/pki_int/crl"

#create a role to generate new certificates
kubectl exec -it vault-0 -- \
vault write pki_int/roles/sandbox.svc.cluster.local \
        allowed_domains="sandbox.svc.cluster.local" \
        allow_subdomains=true \
        max_ttl="720h"

kubectl exec -it vault-0 -- \
vault secrets disable pki

kubectl exec -it vault-0 -- \
vault write -format=json pki_int/issue/sandbox.svc.cluster.local \
    common_name=kafka.sandbox.svc.cluster.local

kubectl exec -it vault-0 -- \
vault write -format=json pki_int/issue/sandbox.svc.cluster.local \
    common_name=zookeeper.sandbox.svc.cluster.local

kubectl exec -it vault-0 -- \
vault write -format=json pki_int/issue/sandbox.svc.cluster.local \
    common_name=ksqldb.sandbox.svc.cluster.local

kubectl exec -it vault-0 -- \
vault write -format=json pki_int/issue/sandbox.svc.cluster.local \
    common_name=controlcenter.sandbox.svc.cluster.local

kubectl exec -it vault-0 -- \
vault write -format=json pki_int/issue/sandbox.svc.cluster.local \
    common_name=connect.sandbox.svc.cluster.local

kubectl exec -it vault-0 -- \
vault write -format=json pki_int/issue/sandbox.svc.cluster.local \
    common_name=registry.sandbox.svc.cluster.local

#create a new policy to create update revoke and list certificates
kubectl exec -it vault-0 -- \
vault policy write pki_int - <<EOF
path "pki_int/issue/*" {
  capabilities = ["create", "update"]
}

path "pki_int/certs" {
  capabilities = ["list"]
}

path "pki_int/revoke" {
  capabilities = ["create", "update"]
}

path "pki_int/tidy" {
  capabilities = ["create", "update"]
}

path "pki/cert/ca" {
  capabilities = ["read"]
}

path "auth/token/renew" {
  capabilities = ["update"]
}

path "auth/token/renew-self" {
  capabilities = ["update"]
}
EOF


kubectl exec -it vault-0 -- \
vault write auth/kubernetes/role/issuer \
    bound_service_account_names=issuer \
    bound_service_account_namespaces=default \
    policies=pki_int \
    ttl=20m

#enable userpass to create an authentication method for creating and managing the certificates
kubectl exec -it vault-0 -- \
vault auth enable userpass

#create a new username and password with the policy we created earlier
kubectl exec -it vault-0 -- \
vault write auth/userpass/users/alice \
    password=alice-secret \
    token_policies="pki_int"

#list all certificates created by the intermediate CA
kubectl exec -it vault-0 -- \
vault list pki_int/certs

exit

kubectl exec -it vault-0 -- \
vault list pki_int/certs > cert_key_list
CERT1=$(sed '3q;d' cert_key_list)
#echo $CERT1
kubectl exec -it vault-0 -- \
vault read  pki_int/cert/"$CERT1"

kubectl exec -it vault-0 -- \
vault write pki_int/revoke serial_number="$CERT1"
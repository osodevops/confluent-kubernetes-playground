kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo


## Create a secret which will store our ldap user credentials
kubectl create secret generic sealed-credential --dry-run=client --from-file=ldap.txt=./ldap.txt --from-file=bearer.txt=./bearer.txt --from-file=plain-jaas.conf=./plain-jaas.conf -o yaml > sealed-credential-source.yaml

## Creat Sealed Secret (this must be created after sealed-secrets has been deployed)
kubeseal --scope cluster-wide <sealed-credential-source.yaml> ./sealed-credential.yaml --controller-name=sealed-secrets --controller-namespace default

kubeseal --scope cluster-wide <sealed-credential-source.yaml> ../environments/base/secrets/sealed-credential.yaml --controller-name=sealed-secrets --controller-namespace default

kubectl apply -f sealed-credential.yaml 
```
sealedsecret.bitnami.com/sealed-credential created
```



## Sealed Secrets
Install a local kubeseal CLI

helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm search repo confluent --versions
helm template sealed-secrets/sealed-secrets --version 2.1.4 --include-crds --output-dir . 




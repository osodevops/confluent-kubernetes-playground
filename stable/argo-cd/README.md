# ArgoCD / Sealed Secrets
This example shows how an argoCD configuration that would allow for a GitOPS deployment for CFK.  

## Features

| Feature         | Enabled | Note                     |
|:----------------|:-------:|:-------------------------|
| Kafka/Zookeeper |    ✅    |                          |
| Control Center  |    ✅    |                          |
| Connect         |    ❌    |                          |
| Schema Registry |    ❌    |                          |
| KSQL            |    ❌    |                          |
| TLS Encryption  |    ✅    | Self-signed certificates |
| Authentication  |    ✅    |                          |
| Authorization   |    ✅    | via LDAP                 |
| ArgoCD          |    ✅    |                          |


### NOTE: You will likely need to run the `kubectl apply -k` command twice as there is a dependency on the CRDs for ArgoCD.

### Obtain initial argoCD admin secret
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

### Access ArgoCD
Port forward the argocd-server on port 8080 to your localhost.  You can log onto the web UI with the credentials 'admin' and password acquired above.

After ArgoCD gets up and running, you will start to see a cluster deployed.  Pay attention to the kustomize.yaml; note how we are not actually deploying the Kafka from the YAML locally, it as actually reaching out to GIT via the ArgoCD Apps.

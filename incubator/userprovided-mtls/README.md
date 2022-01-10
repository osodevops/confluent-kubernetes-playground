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

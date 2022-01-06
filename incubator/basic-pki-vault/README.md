**NOTE!**  

This example is not presently working, as it would seem that [KIP-651](https://cwiki.apache.org/confluence/display/KAFKA/KIP-651+-+Support+PEM+format+for+SSL+certificates+and+private+key) is only available in version 2.7 of Kafka, whereas the latest version of Confluent Kafka at time of writing of is 2.6.

The error when trying to specify PEM files as per documntation is:

```
org.apache.kafka.common.errors.InvalidConfigurationException: SSL key store password cannot be specified with PEM format, only key password may be specified
```
 

**How to run**
(all commands run from this directory)
* Deploy the neccessary CRDs by running `kubectl apply -k ../../kustomize/crds`
* Run `./vault_cert_generation.sh` script which will
  - Install Vault via the official hashicorp/vault helm chart
  - Enable the Vault PKI Secrets & Kubernetes engines
  - Generates a temporary root CA
  - Generates an intermediate CA
  - Sends intermediate CA CSR to the root CA for signing
  - Publishes the signed intermedia CA to vault
  - Creates vault roles/policy which will allow pods to generate certificates (this will be applied to the 'oso-confluent-vault-account' kubernetes service account)
* Deploy the confluent stack `kubectl apply -k .`

As mentioned, this example is presently not working due to the issue mentioned above, if you however would like to see the certifiates in action, you can exec onto the zookeeper-0 pod, and navigate to `/vault/secrets`, where you will see two files: server.cert & server.key
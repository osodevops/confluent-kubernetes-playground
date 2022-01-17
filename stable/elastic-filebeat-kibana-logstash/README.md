# Monitoring (JMX/Prometheus/Grafana)
In this example, we deploy an RBAC enabled Confluent cluster with Prometheus/Grafana integration.

## Deploy Stack
From within this present directory(./examples/monitoring), run the following command:

```shell
kubectl apply -k ../../kustomize/crds && sleep 1 && kubectl apply -k .
```
Once all the pods are in a 'Running' status, we can start to investigate the rest of the stack.

## Kibana
Kibana has a UI you can view by forwarding port 5601 with the following command, and then accessing `http://127.0.0.1:5601` from a local browser.
```shell
kubectl port-forward \
$(kubectl get pods -n sandbox -l app=kibana -o name) \
5601 --namespace sandbox
```
## TODO - All working, but need to detail how to set up kibana (manual steps)
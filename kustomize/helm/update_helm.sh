#!/bin/bash
export CHART_VERSION=0.304.2
#export CHART_VERSION=0.174.25
#export CHART_VERSION=0.174.21
#export CHART_VERSION=0.174.13
helm repo add confluentinc https://packages.confluent.io/helm
helm repo update
helm search repo confluent --versions
helm template confluentinc/confluent-for-kubernetes --version $CHART_VERSION --include-crds --set namespaced=false --output-dir .
mv confluent-for-kubernetes/crds/* ../crds/crds
mv confluent-for-kubernetes/templates/* ../base/operator
rm -R confluent-for-kubernetes
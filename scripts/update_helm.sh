#!/bin/bash

export APP_VERSION=2.4.1
export CHART_VERSION=0.517.23
#export APP_VERSION=2.4.0
#export CHART_VERSION=0.517.12
#export APP_VERSION=2.3.0
#export CHART_VERSION=0.435.11
#export APP_VERSION=2.2.1
#export CHART_VERSION=0.304.17
#export APP_VERSION=2.2.0
#export CHART_VERSION=0.304.2
#export APP_VERSION=2.1.1
#export CHART_VERSION=0.280.22
#export APP_VERSION=2.1.0
#export CHART_VERSION=0.280.1
#export APP_VERSION=2.0.4
#export CHART_VERSION=0.174.34
#export APP_VERSION=2.0.3
#export CHART_VERSION=0.174.25
#export APP_VERSION=2.0.2
#export CHART_VERSION=0.174.21
#export APP_VERSION=2.0.1
#export CHART_VERSION=0.174.13
#export APP_VERSION=2.0.0
#export CHART_VERSION=0.174.6


helm repo add confluentinc https://packages.confluent.io/helm
helm repo update
helm search repo confluent --versions
helm template confluentinc/confluent-for-kubernetes --version $CHART_VERSION --include-crds --set namespaced=false --output-dir .
mkdir -p ../base/cfk-base/$APP_VERSION/crds
mkdir -p ../base/cfk-base/$APP_VERSION/templates
#FIX need to remove old sym link before creating new one
rm ../base/cfk-base/latest && ln -s ./$APP_VERSION ../base/cfk-base/latest

mv confluent-for-kubernetes/crds/* ../base/cfk-base/$APP_VERSION/crds
mv confluent-for-kubernetes/templates/* ../base/cfk-base/$APP_VERSION/templates
rm -R confluent-for-kubernetes
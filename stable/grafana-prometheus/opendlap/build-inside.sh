#!/bin/bash
eval $(minikube docker-env)
docker build -t ldap-exporter:thisone .
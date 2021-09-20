#!/bin/bash
eval $(minikube docker-env)
docker build -t sandbox-custom-logstash .
#!/bin/bash
eval $(minikube docker-env)
docker build -t sandbox-kafka-client .
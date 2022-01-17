#!/bin/bash
eval $(minikube docker-env)
docker build -t connect-gcs .
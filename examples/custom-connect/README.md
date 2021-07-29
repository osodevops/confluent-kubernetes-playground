1. cd into `/examples/custom-connect`

2. start minikube
```shell
minikube start --cpus=6 --memory=16384
```

3. apply confluent crds 
```shell
kubectl apply -k ../../kustomize/infrastructure
```

4. run docker build for connect image into minikube
```shell
./build-inside.sh
```   

5. deploy confluent platform and connector
```shell
kubectl apply -k .
```


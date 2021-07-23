As the README describes, you can reuse the Docker daemon from Minikube with eval $(minikube docker-env).

So to use an image without uploading it, you can follow these steps:

Set the environment variables with eval $(minikube docker-env)
Build the image with the Docker daemon of Minikube (eg docker build -t my-image .)
Set the image in the pod spec like the build tag (eg my-image)
Set the imagePullPolicy to Never, otherwise Kubernetes will try to download the image.
Important note: You have to run eval $(minikube docker-env) on each terminal you want to use, since it only sets the environment variables for the current shell session




/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "nbBg8G4DkR83Xs"

select name from sys.databases
go


Deploying a connector:

curl -X POST -H "Content-Type: application/json" --data @config.json http://localhost:8083/connectors

Connect REST API Docs:
https://docs.confluent.io/platform/current/connect/references/restapi.html


curl -X POST -H "Content-Type: application/json" https://localhost:8083/connectors
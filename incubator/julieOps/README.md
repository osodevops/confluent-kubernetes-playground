### Running julieOps as a docker image
```
docker run -t -i \
      -v /home/mccullya/Projects/oso/confluent-kubernetes-playground/incubator/julieOps:/example \
      purbon/kafka-topology-builder:latest \
      julie-ops-cli.sh \
      --brokers pkc-8vkm7.eu-west-2.aws.confluent.cloud:9092 \
      --clientConfig /example/topology-builder-with-schema-cloud.properties \
      --plans /example/plans.yaml \
      --topology /example/descriptor.yaml -quiet
```

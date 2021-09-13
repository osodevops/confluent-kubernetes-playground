FROM confluentinc/cp-server-connect-operator:6.1.2.1
USER root

ENV CONNECT_PLUGIN_PATH="/usr/share/java,/usr/share/confluent-hub-components"

RUN echo Importing connector plugins \
    && confluent-hub install --no-prompt confluentinc/kafka-connect-gcp-spanner:latest \
    && confluent-hub install --no-prompt confluentinc/kafka-connect-gcs:latest \
    && echo Connector plugins imported

USER 1001
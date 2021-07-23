FROM confluentinc/cp-server-connect-operator:6.1.2.1
USER root
ENV CONNECT_PLUGIN_PATH="/usr/share/java,/usr/share/confluent-hub-components"
RUN confluent-hub install --no-prompt debezium/debezium-connector-sqlserver:1.6.0
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.1.1
USER 1001
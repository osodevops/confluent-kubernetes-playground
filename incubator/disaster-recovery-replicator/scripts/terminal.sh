'AclBinding' object is not iterable
kafka-acls --command-config /tmp/clientsettings.txt --bootstrap-server kafka:9071 --list --topic pagesviews


kafka-acls --command-config /tmp/clientsettings.txt --bootstrap-server kafka:9071 --topic pageviews --add --deny-principal user:alice
kafka-acls --command-config /tmp/clientsettings.txt --bootstrap-server kafka:9071  --add --deny-principal User:alice —operation All --topic inventory -force


1
./kafka–acls.sh —bootstrap–server public_ip_of_kafka_node:9092 —command–config kafka.properties —add —deny–principal User:test —operation All —topic test —force

kafka-acls --command-config /tmp/clientsettings.txt --bootstrap-server kafka:9071 --topic pageviews --remove --deny-principal user:aliceasdf
QA
tee -a /tmp/clientsettings.txt > /dev/null <<EOT
bootstrap.servers=kafka:9071
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="kafka" password="kafka-secret" ;
sasl.mechanism=PLAIN
security.protocol=SASL_SSL
ssl.truststore.location=/mnt/sslcerts/truststore.jks
ssl.truststore.password=mystorepassword
ssl.truststore.type=jks
EOT

kafka-consumer-groups --bootstrap-server kafka:9071 --command-config /tmp/clientsettings.txt --all-groups --reset-offsets --to-datetime 2022-09-22T15:30:00.000 --execute

--bootstrap-server




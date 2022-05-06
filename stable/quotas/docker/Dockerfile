FROM rockylinux/rockylinux:8.5

ENV container docker

# 1. Adding Confluent repository
RUN rpm --import https://packages.confluent.io/rpm/7.1/archive.key
COPY confluent.repo /etc/yum.repos.d/confluent.repo
RUN yum clean all

# 2. Install Confluent Kafka stack
RUN yum install -y java-1.8.0-openjdk
RUN yum install -y confluent-kafka

# 3. Install JY YAML parser for shell
RUN yum install -y jq
RUN curl -L -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/`curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | jq .tag_name | sed 's/"//g'`/yq_linux_amd64
RUN chmod 755 /usr/local/bin/yq
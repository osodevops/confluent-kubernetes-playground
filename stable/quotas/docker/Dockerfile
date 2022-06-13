FROM confluentinc/cp-kafka:latest
USER root
RUN yum install -y jq vim vi
RUN curl -L -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/`curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | jq .tag_name | sed 's/"//g'`/yq_linux_amd64
RUN  chmod +x /usr/local/bin/yq
USER appuser

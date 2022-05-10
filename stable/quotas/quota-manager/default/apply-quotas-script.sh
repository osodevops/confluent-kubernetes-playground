#!/bin/bash
quota_definition="/tmp/quota-definition/quotas.yaml"
for i in $(yq '.platform.quotas | keys' < $quota_definition); do
  principal="${i:0}"
  if [[ "$principal" != "-" ]]; then
    producer_byte_rate=$(yq ".platform.quotas.$principal.producer_byte_rate" < $quota_definition)
    consumer_byte_rate=$(yq ".platform.quotas.$principal.consumer_byte_rate" < $quota_definition)
    request_percentage=$(yq ".platform.quotas.$principal.request_percentage" < $quota_definition)
    config_string=""
    if [[ "$producer_byte_rate" != "null" ]]; then
      config_string="$config_string producer_byte_rate=$producer_byte_rate,"
    fi
    if [[ "$consumer_byte_rate" != "null" ]]; then
      config_string="$config_string consumer_byte_rate=$consumer_byte_rate,"
    fi
    if [[ "$request_percentage" != "null" ]]; then
      config_string="$config_string request_percentage=$request_percentage,"
    fi
    # Removes white space and the last trailing comma
    config=$(echo $config_string | tr -d " \t\n\r" | rev | cut -c 2- | rev)
    echo $config
    set -x
    if [[ "$principal" == "global" ]]; then
      kafka-configs \
      --bootstrap-server kafka:9071 \
      --alter \
      --entity-type users \
      --entity-default \
      --command-config /tmp/config-properties/kafka.properties \
      --add-config "$config"
    else
      kafka-configs \
      --bootstrap-server kafka:9071 \
      --alter \
      --entity-type users \
      --entity-name $principal \
      --command-config /tmp/config-properties/kafka.properties \
      --add-config "$config"
    fi
    set +x
  fi
done


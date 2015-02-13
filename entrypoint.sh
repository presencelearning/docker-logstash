#!/bin/bash

FORWARDER_DIR=/mnt/logstash-forwarder
if [ ! -f "$FORWARDER_DIR/logstash-forwarder.key" ]; then
    echo "Generating new logstash-forwarder key"
    openssl req -x509 -batch -nodes -newkey rsa:4096 -keyout "$FORWARDER_DIR/logstash-forwarder.key" -out "$FORWARDER_DIR/logstash-forwarder.crt" -subj '/CN=*'
fi

config=$(</etc/logstash/logstash.conf);
if [ -n "$ELASTICSEARCH_PORT_9200_TCP_ADDR" ]; then
  config=${config//host => \"elasticsearch\"/host => \"$ELASTICSEARCH_PORT_9200_TCP_ADDR\"};
fi
if [ -n "$ELASTICSEARCH_PORT_9200_TCP_PORT" ]; then
  config=${config//port => \"9200\"/port => \"$ELASTICSEARCH_PORT_9200_TCP_PORT\"};
fi
printf '%s\n' "$config" >/etc/logstash/logstash.conf

exec "$@"

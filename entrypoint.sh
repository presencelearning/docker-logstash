#!/bin/bash

FORWARDER_DIR=/opt/logstash/certificates
if [ ! -f "$FORWARDER_DIR/logstash-forwarder.key" ]; then
    echo "Generating new logstash-forwarder key"
    openssl req -x509 -batch -nodes -newkey rsa:4096 -keyout "$FORWARDER_DIR/logstash-forwarder.key" -out "$FORWARDER_DIR/logstash-forwarder.crt" -subj '/CN=*'
fi

eval "$@"

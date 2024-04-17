#!/bin/bash

function constants() {
    SERVERNAME=heroSurfa
    FQDN=$SERVERNAME.herodmain.com
    IPADDR="8.8.8.8"
}

function createKeyWithCSR() {
    openssl req -new -nodes \
    -subj "/C=DE/CN=$SERVERNAME/OU=IT/O=Dev00ps/L=Springfield/ST=Papal States" \
    -addext "subjectAltName = DNS:$SERVERNAME,DNS:$FQDN,IP.1:$IPADDR" \
    -newkey rsa:4096 -keyout $SERVERNAME.key -out $SERVERNAME.csr
}

function main() {
    constants
    createKeyWithCSR
}

main "$@"

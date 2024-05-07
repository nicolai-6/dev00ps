#!/bin/bash
#### requires at least openssl 1.1.1 version to make use of state-of-the-art curves

function constants() {
    CURVE=secp384r1
    BASENAME="root_ca"
    PRIV_DIR=./private
    CERT_DIR=./certs
    CSR_DIR=./csr
    CNF=./root_ca.cnf
    CNF_EXT="v3_ca"
    X509_SUBJECT='/C=DE/O=dev0Ops/OU=DevOps/CN=dev0Ops Root CA - 1'
}

#### root key ####
## create root ca key and encrypt it - will prompt for passphrase
function create_key() {
    openssl genpkey \
    -aes256 \
    -algorithm EC \
    -pkeyopt ec_paramgen_curve:$CURVE \
    -out $PRIV_DIR/$BASENAME.key
    # chmod key
    chmod 400 $PRIV_DIR/$BASENAME.key
}

#### create CSR ####
function create_csr() {
    openssl req -new \
    -sha512 \
    -subj "$X509_SUBJECT" \
    -key $PRIV_DIR/$BASENAME.key \
    -out $CSR_DIR/$BASENAME.csr \
    -config $CNF
}

#### self-sign our root certificate ####
function sign() {
    openssl ca -selfsign \
    -in $CSR_DIR/$BASENAME.csr  \
    -out $CERT_DIR/$BASENAME.pem \
    -config $CNF \
    -extensions $CNF_EXT \
    -startdate `date +%y%m%d000000Z -u -d -1day` \
    -enddate `date +%y%m%d000000Z -u -d +15years+1day` \
    -batch # disable prompts and silently sign certificates
}

function main {
    constants
    create_key
    create_csr
    sign
}

main "$@"

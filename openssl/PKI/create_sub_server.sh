#!/bin/bash
#### requires at least openssl 1.1.1 version to make use of state-of-the-art curves

function constants() {
    CURVE=secp384r1
    BASENAME="sub_ca_server"
    ROOT_CA=root_ca # singing CA
    PRIV_DIR=./private
    CERT_DIR=./certs
    CSR_DIR=./csr
    CNF=root_ca.cnf
    CNF_EXT="v3_signing_ica"
    X509_SUBJECT='/C=DE/O=dev0Ops/OU=DevOps/CN=dev0Ops Sub CA Server - 1'
    CA_SERIAL=./db/root-ca.serial
}

#### sub ca key ####
## create sub ca server key and encrypt it - will prompt for passphrase
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

#### sign intermediate / sub ca with ca ####
function sign() {
    openssl x509 -req \
    -sha512 \
    -days 3650 \
    -in $CSR_DIR/$BASENAME.csr \
    -CA $CERT_DIR/$ROOT_CA.pem \
    -CAkey $PRIV_DIR/$ROOT_CA.key \
    -CAserial $CA_SERIAL \
    -out $CERT_DIR/$BASENAME.pem \
    -extfile $CNF \
    -extensions $CNF_EXT
}

function main() {
    constants
    create_key
    create_csr
    sign
}

main "$@"
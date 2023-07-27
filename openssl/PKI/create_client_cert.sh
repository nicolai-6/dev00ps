#!/bin/bash
#### requires at least openssl 1.1.1 version to make use of state-of-the-art curves

### RUNBOOK / USAGE
### we have to pass mandatory parameters: b: basename, c: commonName, d: DNS, e: email
### ./create_client_cert.sh \
### -b "client.dev0Ops.de" \
### -c "client.dev0Ops.de" \
### -d "client.dev0Ops.de" \
### -e "client@dev0Ops.de"

# "constants"
function constants() {
    CURVE=secp384r1
    ROOT_CA=sub_ca_client # singing CA
    PRIV_DIR=./private
    CERT_DIR=./certs
    CSR_DIR=./csr
    CNF=root_ca.cnf
    CA_SERIAL=./db/root-ca.serial
    BASENAME=$basename
}

## create server key and encrypt it - will prompt for passphrase
function create_key() {
    openssl genpkey \
    -algorithm EC \
    -pkeyopt ec_paramgen_curve:$CURVE \
    -out $PRIV_DIR/$BASENAME.key
    # chmod key
    chmod 400 $PRIV_DIR/$BASENAME.key
}

#### create CSR ####
function create_csr() {
    X509_SUBJECT='/C=DE/O=dev0Ops/OU=DevOps/CN='"$common_name"
    SAN_REQ="subjectAltName=DNS:$dns,email:$email"

    openssl req -new \
    -sha512 \
    -subj "$X509_SUBJECT" \
    -addext "$SAN_REQ" \
    -key $PRIV_DIR/$BASENAME.key \
    -out $CSR_DIR/$BASENAME.csr \
    -config $CNF
}

#### sign with according sub ca ####
function sign() {
    openssl x509 -req \
    -sha512 \
    -days 1460 \
    -in $CSR_DIR/$BASENAME.csr \
    -CA $CERT_DIR/$ROOT_CA.pem \
    -CAkey $PRIV_DIR/$ROOT_CA.key \
    -CAserial $CA_SERIAL \
    -out $CERT_DIR/$BASENAME.pem \
    -extfile <(printf \
    "basicConstraints=critical, CA:FALSE\n \
    subjectKeyIdentifier=hash\n \
    authorityKeyIdentifier=keyid, issuer\n \
    keyUsage=critical, digitalSignature, keyEncipherment\n \
    extendedKeyUsage=critical, clientAuth\n \
    subjectAltName=DNS:$dns,email:$email")
}

function main()  {
    #get_args
    while getopts b:c:d:e: flag
    do
        case "${flag}" in
            b) basename=${OPTARG};;
            c) common_name=${OPTARG};;
            d) dns=${OPTARG};;
            e) email=${OPTARG};;
        esac
    done

    printf "basename: $basename\n"
    printf "CommonName: $common_name\n"
    printf "DNS: $dns\n"
    printf "email: $email\n"

    constants
    create_key
    create_csr
    sign
}

main "$@"

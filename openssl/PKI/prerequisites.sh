#!/bin/bash
######## prerequisites ########
### this should only run once
### normally do not run this script again!
### we omit a certificate revocation list (CRL)

# create ca index file (leave blank)
# This file maintains an index of all certificates issued and is covered under the Index Section below
# Maintains a record of all certs issued, and is extremely important if one has revoked a certificate.

# Create "crlnumber" file:
# This file maintains the current serial for the CRL [Certificate Revocation List] certificate
# A CRL should be generated, but will not be used until one revokes a certificate via one's CA or ICA
## we do not plan to use it but we include it for the sake of completeness

# create serial file
# This file maintains the serial for the most recent cert, in order to know what serial to next assign.
# Serial is in hex, not dec[imal] format, & one can choose whichever number one wishes to start at

read -p "Do you really want to continue (y/n)?" choice
case "$choice" in 
  y|Y ) echo "generating directories and files"
        mkdir -p {csr,certs,new_certs,private,db}
        touch db/root-ca.index 
        echo 00 > db/root-ca.crlnum 
        openssl rand -hex 16 > db/root-ca.serial ;; # Using random instead of incremental serial numbers is a recommended security practice
  n|N ) echo "exit"
        exit 0 ;;
  * )   echo "invalid"
        exit 1 ;;
esac

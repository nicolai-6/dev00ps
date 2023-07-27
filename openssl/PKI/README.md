# basic openssl PKI

## RUNBOOK
    - run prerequisites.sh once
    - run create_root_ca.sh once
    - run create_sub_client.sh once
    - run create_sub_server.sh once
    - signing certificates is possible as of now (client certificates, server certificates, server certificates including SAN IP address)
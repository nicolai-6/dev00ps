# simple mutual TLS Nats client implementation enforcing TLS version 1.2
    - intention is to check the supported TLS versions of a remote Nats server / or Nats Leaf Node
    - in this case we try to connect via TLS 1.2 (can be adjusted with some minor changes)
    - There is no further processing of the server response, we just expect a "dirty" successfully established connection

## RUNBOOK
    - add ca_server_bundle.pem content
    - add certificate.pem content
    - add private.key content
    - in main.py adjust nats_address and nats_hostheader variables
    - install requirements and run main.py
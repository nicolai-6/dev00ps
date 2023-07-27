# motivation is to provide VPN connectivity for a K8s pod
    - running this container as a sidecar for another container in a pod provides VPN connectivity

## RUNBOOK
    - optioanlly adjust ipsec.conf / strongswan.conf
    - optionally adjust BUILD_TAG and run build.sh (has to be adjusted in further scripts as well)
    - adjust DOCKER_REG address and run push_to_reg.sh
    - adjust VPN environment variables in docker-compose.yaml and run compose up
    - as an alternative run the k8s deployment k8s/deployment.yaml (adjust image address in deployment.yaml and container spec environments)

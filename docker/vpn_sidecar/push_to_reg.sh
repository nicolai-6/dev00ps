#!/bin/bash
## first build image build.sh

DOCKER_REG="registryHeroDomain"

# tag
docker tag strongswan-do:1 $DOCKER_REG/vpn-sidecar:v2
# push
docker push $DOCKER_REG/vpn-sidecar:v2
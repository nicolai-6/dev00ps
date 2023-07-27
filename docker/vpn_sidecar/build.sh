#!/bin/bash
# build docker image
BUILD_TAG=2
docker build -t strongswan-do:$BUILD_TAG .
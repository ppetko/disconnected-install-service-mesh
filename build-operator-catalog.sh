#!/bin/bash

DATE=$(date +%Y-%m-%d-%H:%M:%S)

function log(){
    echo "$DATE INFO $@"
    return 0
}

function panic(){
    echo "$DATE ERROR $@"
    exit 1
}

if [ $# -lt 1 ]; then
    panic  "Usage: $0 Registry URL"
fi

REGISTRY=$1

if [ ! -d "./manifests" ]; then
	panic "./manifests doesn't exist"
fi

podman build --no-cache -f Dockerfile \
    -t ${REGISTRY}/openshift-marketplace/mirrored-operator-catalog

podman push ${REGISTRY}/openshift-marketplace/mirrored-operator-catalog

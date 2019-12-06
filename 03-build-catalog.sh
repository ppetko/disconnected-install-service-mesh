#!/bin/bash

./get-operator.sh redhat-operators servicemeshoperator
./get-operator.sh redhat-operators kiali-ossm
./get-operator.sh redhat-operators jaeger-product

untar all of them 

REGISTRY=$(uname -n)

podman build --no-cache -f Dockerfile \
    -t ${REGISTRY}/openshift-marketplace/mirrored-operator-catalog

podman push ${REGISTRY}/openshift-marketplace/mirrored-operator-catalog

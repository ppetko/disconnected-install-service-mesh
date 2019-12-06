#!/bin/bash

podman build --no-cache -f Dockerfile \
    -t default-route-openshift-image-registry.apps.ocp-cluster.rhfsipractice.com/openshift-marketplace/mirrored-operator-catalog:v1

podman push default-route-openshift-image-registry.apps.ocp-cluster.rhfsipractice.com/openshift-marketplace/mirrored-operator-catalog:v1

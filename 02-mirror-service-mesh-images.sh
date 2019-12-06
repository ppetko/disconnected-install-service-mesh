#!/bin/bash 


images=(
registry.redhat.io/distributed-tracing/jaeger-all-in-one-rhel7:1.13.1
registry.redhat.io/distributed-tracing/jaeger-rhel7-operator:1.13.1
registry.redhat.io/openshift-service-mesh/kiali-rhel7-operator:1.0.6
registry.redhat.io/openshift-service-mesh/kiali-rhel7:1.0.6
registry.redhat.io/openshift-service-mesh/istio-rhel8-operator:1.0.1
registry.redhat.io/openshift4/ose-oauth-proxy:4.1
registry.redhat.io/openshift4/ose-oauth-proxy:latest
registry.redhat.io/openshift-service-mesh/citadel-rhel8:1.0.1
registry.redhat.io/openshift-service-mesh/galley-rhel8:1.0.1
registry.redhat.io/openshift-service-mesh/grafana-rhel8:1.0.1
registry.redhat.io/openshift-service-mesh/istio-cni-rhel8:1.0.1
registry.redhat.io/openshift-service-mesh/istio-rhel8-operator:1.0.1
registry.redhat.io/openshift-service-mesh/mixer-rhel8:1.0.1
registry.redhat.io/openshift-service-mesh/pilot-rhel8:1.0.1
registry.redhat.io/openshift-service-mesh/prometheus-rhel8:1.0.1
registry.redhat.io/openshift-service-mesh/proxyv2-rhel8:1.0.1
registry.redhat.io/openshift-service-mesh/sidecar-injector-rhel8:1.0.1
)

for image in ${images[@]}; do
	src=$image
	dst=registry.example.com/${image#*/}
	echo "skopeo copy --format=v2s2 docker://$src docker://$dst"
done

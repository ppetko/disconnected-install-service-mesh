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

images=(
distributed-tracing/jaeger-agent-rhel7:1.13.1
distributed-tracing/jaeger-all-in-one-rhel7:1.13.1
distributed-tracing/jaeger-collector-rhel7:1.13.1
distributed-tracing/jaeger-es-index-cleaner-rhel7:1.13.1
distributed-tracing/jaeger-query-rhel7:1.13.1
distributed-tracing/jaeger-rhel7-operator:1.13.1
kiali-rhel7:1.0.7
kiali-rhel7-operator:1.0.7
maistra/examples-bookinfo-details-v1:0.12.0
maistra/examples-bookinfo-productpage-v1:0.12.0
maistra/examples-bookinfo-ratings-v1:0.12.0
maistra/examples-bookinfo-reviews-v1:0.12.0
maistra/examples-bookinfo-reviews-v2:0.12.0
maistra/examples-bookinfo-reviews-v3:0.12.0
openshift-marketplace/mirrored-operator-catalog:latest
openshift-service-mesh/citadel-rhel8:1.0.2
openshift-service-mesh/citadel-rhel8:1.0.1
openshift-service-mesh/galley-rhel8:1.0.2
openshift-service-mesh/galley-rhel8:1.0.1
openshift-service-mesh/grafana-rhel8:1.0.2
openshift-service-mesh/grafana-rhel8:1.0.1
openshift-service-mesh/istio-cni-rhel8:1.0.2
openshift-service-mesh/istio-cni-rhel8:1.0.1
openshift-service-mesh/istio-rhel8-operator:1.0.2
openshift-service-mesh/istio-rhel8-operator:1.0.1
openshift-service-mesh/kiali-rhel7:1.0.6
openshift-service-mesh/kiali-rhel7:1.0.7
openshift-service-mesh/kiali-rhel7-operator:1.0.6
openshift-service-mesh/kiali-rhel7-operator:1.0.7
openshift-service-mesh/mixer-rhel8:1.0.2
openshift-service-mesh/mixer-rhel8:1.0.1
openshift-service-mesh/pilot-rhel8:1.0.2
openshift-service-mesh/pilot-rhel8:1.0.1
openshift-service-mesh/prometheus-rhel8:1.0.2
openshift-service-mesh/prometheus-rhel8:1.0.1
openshift-service-mesh/proxyv2-rhel8:1.0.2
openshift-service-mesh/proxyv2-rhel8:1.0.1
openshift-service-mesh/sidecar-injector-rhel8:1.0.2
openshift-service-mesh/sidecar-injector-rhel8:1.0.1
openshift4/ose-elasticsearch-operator:latest
openshift4/ose-logging-elasticsearch5:latest
openshift4/ose-oauth-proxy:latest
openshift4/ose-oauth-proxy:4.1
)

for image in ${images[@]}; do
	src=$image
	dst=${REGISTRY}/${image#*/}
	skopeo copy --format=v2s2 docker://$src docker://$dst
done

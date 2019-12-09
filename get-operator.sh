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

if [ "x$(which jq)" == "x" ]; then
    panic "Missing jq"
fi

if [ $# -lt 2 ]; then
    panic  "Usage: $0 NAMESPACE PACKAGE"
fi

PKG_NAMESPACE=$1
PKG_NAME=$2

RELEASE=$(curl -s -H "Authorization: ${QUAY_AUTH_TOKEN}" "https://quay.io/cnr/api/v1/packages?namespace=${PKG_NAMESPACE}" | jq '.[] | select(.name == "'$PKG_NAMESPACE'" + "/" + "'$PKG_NAME'") | .default' | tr -d '"')

DIGEST=$(curl -s -H "Authorization: ${QUAY_AUTH_TOKEN}" "https://quay.io/cnr/api/v1/packages/$PKG_NAMESPACE/$PKG_NAME/$RELEASE" | jq '.[].content.digest'| tr -d '"')

if [ -z "${RELEASE}" ] || [ -z "${DIGEST}" ]; then
        panic "populate release and/or digest"
fi

log "Downloading ${PKG_NAMESPACE}/${PKG_NAME} ${RELEASE} release using ${DIGEST}"

FILENAME="${PKG_NAMESPACE}-${PKG_NAME}-${RELEASE}.tar.gz"

curl -s -H "Authorization: ${QUAY_AUTH_TOKEN}" \
        "https://quay.io/cnr/api/v1/packages/$PKG_NAMESPACE/$PKG_NAME/blobs/sha256/$DIGEST" -o "${FILENAME}"

log "Downloading file $FILENAME"

# Disconnected Install Red Hat Service Mesh (Istio)

## Disable the default OperatorSources.

```
$ oc patch OperatorHub cluster --type json \
    -p '[{"op": "add", "path": "/spec/disableAllDefaultSources", "value": true}]'
```

## Pull Operator content.

```
./get-operator.sh redhat-operators elasticsearch-operator
./get-operator.sh redhat-operators kiali-ossm
./get-operator.sh redhat-operators jaeger-product
./get-operator.sh redhat-operators servicemeshoperator

```

## Pre build setup

```
mkdir manifests ; for f in *.tar.gz; do tar -C manifests/ -xvf $f ; done && rm -rf *tar.gz

```

## Create an Operator catalog image and push it to registry

```
export REGISTRY="YOUR_REGISTRY_URL"

podman build --no-cache -f Dockerfile \
    -t ${REGISTRY}/openshift-marketplace/mirrored-operator-catalog

podman push ${REGISTRY}/openshift-marketplace/mirrored-operator-catalog

OR

./build-operator-catalog.sh YOUR_REGISTRY_URL

```

### Modify /etc/containers/registries.conf and set mirror-by-digest-only = false

```
cat sample-registries.conf | base64

```

### Replace ${YOUR_FILE_CONTENT_IN_BASE64} with the output of the previous command

```
apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig
metadata:
  annotations:
  labels:
    machineconfiguration.openshift.io/role: worker
  name: 50-worker-container-registry-conf
spec:
  config:
    ignition:
      version: 2.2.0
    storage:
      files:
      - contents:
          source: data:text/plain;charset=utf-8;base64,${YOUR_FILE_CONTENT_IN_BASE64}
          verification: {}
        filesystem: root
        mode: 420
        path: /etc/containers/registries.conf
```

### Then, apply the config file 

```
oc apply -f sample-registries.conf
```

### Create CatalogSource
* Replace ${REGISTRY} with YOUR_REGISTRY_URL

```
echo "apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: internal-mirrored-operatorhub-catalog
  namespace: openshift-marketplace
spec:
  displayName: My Mirrored Operator Catalog
  sourceType: grpc
  image: ${REGISTRY}/openshift-marketplace/mirrored-operator-catalog
" > internal-mirrored-operatorhub-catalog.yaml

```
## Apply the CatalogSource

```
oc create -f internal-mirrored-operatorhub-catalog.yaml
```

## Check status

```
oc get pods -n openshift-marketplace
oc get catalogsource -n openshift-marketplace
oc describe catalogsource internal-mirrored-operatorhub-catalog -n openshift-marketplace

```

### ServiceMeshMemberRoll
* The Service Mesh operator has installed a control plane configured for multitenancy. This installation reduces the scope of the control plane to only those projects/namespaces listed in a ServiceMeshMemberRoll.
* Create a ServiceMeshMemberRoll resource with the project/namespaces you wish to be part of the mesh. This ServiceMeshMemberRoll is required to be named default and exist in the same namespace where the ServiceMeshControlPlane resource resides (ie: istio-system).

```
echo "apiVersion: maistra.io/v1
kind: ServiceMeshMemberRoll
metadata:
  name: default
spec:
  members:
  # a list of projects joined into the service mesh
  - mesh-tutorial
" > service-mesh-roll.yaml
```

```
$ oc apply -f service-mesh-roll.yaml -n istio-system
```

### Update Security Context Contraints
```
$ oc adm policy add-role-to-user edit YOURUSER -n istio-system
```

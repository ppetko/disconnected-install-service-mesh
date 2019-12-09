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

## Create an Operator catalog image

```
mkdir manifets
./build-operator-catalog.sh 

```

## Push the Operator catalog image to a registry. 

```
oc create -f internal-operatorhub-catalog.yaml
oc get pods -n openshift-marketplace
oc get catalogsource -n openshift-marketplace
oc get packagemanifest -n openshift-marketplace

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

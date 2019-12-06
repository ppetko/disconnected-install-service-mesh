# disconnect-install-operators

### Installing the Service Mesh involves :
* Installing Elasticsearch, Jaeger, Kiali
* Installing the Service Mesh Operator
* Creating and managing a ServiceMeshControlPlane resource to deploy the Service Mesh control plane
* Creating a ServiceMeshMemberRoll resource to specify the namespaces associated with the Service Mesh.

### Download Operators bits 

```
./get-operator.sh redhat-operators elasticsearch-operator
./get-operator.sh redhat-operators kiali-ossm
./get-operator.sh redhat-operators jaeger-product

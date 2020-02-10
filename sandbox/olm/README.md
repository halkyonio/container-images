# OLM on k8s

The following document details the steps to follow to install the Operator Lifecycle Manager - `OLM` on a kubernetes cluster. 
The `OLM` manages different CRDs: `ClusterServiceVersion`, `InstallPlan`, `Subscription` and `OperatorGroup` which are used
to install an Operator using a subscription from a catalog.

The `CatalogSource` CRD allows to specify an external registry to poll the operators published on `quay.io` as a collection of packages/bundles.

More information is available at this [address](https://github.com/operator-framework/community-operators/blob/master/docs/testing-operators.md#testing-operator-deployment-on-kubernetes)

## Instructions

- ssh to a vm running a Kubernetes cluster
- Execute the following bash script to install the 2 operators managed by OLM: olm and catalog operator like also the different CRDs
```bash
./olm.sh 0.14.1
```

# Install an additional catalog of operators

It is possible to install additional `Catalog(s)` of `operators` if you deploy top of a cluster the `Operator-marketplace`. This operator allows to fetch from an external repository
called an `operatorsource`, the metadata of the registry containing your operator packaged as a bundle or `upstream`, `community` or `certified operators.

This operator manages 2 CRDs: the `OperatorSource` and `CatalogSourceConfig`. The `OperatorSource` defines the external datastore that we are using to store operator bundles.
The `CatalogSourceConfig` is used to create an `OLM CatalogSource` consisting of operators from one `OperatorSource` so that these operators can then be managed by `OLM`.

## Instructions

- Install the `Operator Marketplace` and the `OperatorSource` containing the registry information of the community operators.
  **Note**: The upstream community operators are packaged on a quay.io registry as a collection of `bundles` containing the CRDs, package definition and ClusterServiceVersion.
```bash
git clone https://github.com/operator-framework/operator-marketplace.git
kubectl --validate=false apply -f operator-marketplace/deploy/upstream/
```

## Verify the catalog

- Check if the `OperatorSource` has been well deployed
```bash
kubectl get OperatorSource -A
NAMESPACE     NAME                           TYPE          ENDPOINT              REGISTRY                       DISPLAYNAME                    PUBLISHER   STATUS      MESSAGE                                       AGE
marketplace   upstream-community-operators   appregistry   https://quay.io/cnr   upstream-community-operators   Upstream Community Operators   Red Hat     Succeeded   The object has been successfully reconciled   28m
```

- Next, verify if a `CatalogSource` has been created. This `catalogSource` contains the information needed to create a local grpc server 
```bash
kubectl get catalogsource -n marketplace
NAME                           DISPLAY                        TYPE   PUBLISHER   AGE
upstream-community-operators   Upstream Community Operators   grpc   Red Hat     30m
```

- Once the `OperatorSource` and `CatalogSource` are deployed, the following command can be used to list of the available operators specified with the field `.status.packages`:
```bash
kubectl get opsrc upstream-community-operators -n marketplace -o=custom-columns=NAME:.metadata.name,PACKAGES:.status.packages
NAME                           PACKAGES
upstream-community-operators   kong,jaeger,microcks,istio,twistlock,storageos,etcd,prometheus,planetscale,strimzi-kafka-operator,percona,synopsys,sysdig,spinnaker-operator,kubevirt,aws-service,couchbase-enterprise,aqua,federatorai,cockroachdb,instana-agent,camel-k,federation,kiali,hazelcast-enterprise,redis-enterprise,postgresql,oneagent,vault,infinispan,robin-operator,mongodb-enterprise,myvirtualdirectory,opsmx-spinnaker-operator,spark-gcp
```
**NOTE**: The list of the packages can also be displayed using the following command : 
```bash
kubectl get packagemanifests -n marketplace
NAME                                CATALOG                        AGE
storageos                           Upstream Community Operators   2d16h
strimzi-kafka-operator              Upstream Community Operators   2d16h
redis-enterprise                    Upstream Community Operators   2d16h
oneagent                            Upstream Community Operators   2d16h
spark-gcp                           Upstream Community Operators   2d16h
vault                               Upstream Community Operators   2d16h
kubevirt                            Upstream Community Operators   2d16h
spinnaker-operator                  Upstream Community Operators   2d16h
postgresql                          Upstream Community Operators   2d16h
synopsys                            Upstream Community Operators   2d16h
istio                               Upstream Community Operators   2d16h
federation                          Upstream Community Operators   2d16h
aws-service                         Upstream Community Operators   2d16h
mongodb-enterprise                  Upstream Community Operators   2d16h
camel-k                             Upstream Community Operators   2d16h
federatorai                         Upstream Community Operators   2d16h
microcks                            Upstream Community Operators   2d16h
opsmx-spinnaker-operator            Upstream Community Operators   2d16h
prometheus                          Upstream Community Operators   2d16h
sysdig                              Upstream Community Operators   2d16h
twistlock                           Upstream Community Operators   2d16h
couchbase-enterprise                Upstream Community Operators   2d16h
kong                                Upstream Community Operators   2d16h
infinispan                          Upstream Community Operators   2d16h
aqua                                Upstream Community Operators   2d16h
percona                             Upstream Community Operators   2d16h
etcd                                Upstream Community Operators   2d16h
myvirtualdirectory                  Upstream Community Operators   2d16h
planetscale                         Upstream Community Operators   2d16h
jaeger                              Upstream Community Operators   2d16h
kiali                               Upstream Community Operators   2d16h
hazelcast-enterprise                Upstream Community Operators   2d16h
cockroachdb                         Upstream Community Operators   2d16h
instana-agent                       Upstream Community Operators   2d16h
robin-operator                      Upstream Community Operators   2d16h
mongodb-enterprise                  Community Operators            2d16h
tidb-operator                       Community Operators            2d16h
kubestone                           Community Operators            2d16h
ffdl                                Community Operators            2d16h
sematext                            Community Operators            2d16h
ext-postgres-operator               Community Operators            2d16h
noobaa-operator                     Community Operators            2d16h
anchore-engine                      Community Operators            2d16h
sysdig                              Community Operators            2d16h
postgresql                          Community Operators            2d16h
spark-gcp                           Community Operators            2d16h
iot-simulator                       Community Operators            2d16h
myvirtualdirectory                  Community Operators            2d16h
aqua                                Community Operators            2d16h
twistlock                           Community Operators            2d16h
knative-eventing-operator           Community Operators            2d16h
traefikee-operator                  Community Operators            2d16h
clickhouse                          Community Operators            2d16h
vault                               Community Operators            2d16h
jenkins-operator                    Community Operators            2d16h
percona-server-mongodb-operator     Community Operators            2d16h
argocd-operator                     Community Operators            2d16h
rqlite-operator                     Community Operators            2d16h
mattermost-operator                 Community Operators            2d16h
planetscale                         Community Operators            2d16h
camel-k                             Community Operators            2d16h
cockroachdb                         Community Operators            2d16h
apicast-community-operator          Community Operators            2d16h
opsmx-spinnaker-operator            Community Operators            2d16h
kong                                Community Operators            2d16h
eunomia                             Community Operators            2d16h
keycloak-operator                   Community Operators            2d16h
nuodb-operator-bundle               Community Operators            2d16h
litmuschaos                         Community Operators            2d16h
lightbend-console-operator          Community Operators            2d16h
portworx                            Community Operators            2d16h
strimzi-kafka-operator              Community Operators            2d16h
container-security-operator         Community Operators            2d16h
istio                               Community Operators            2d16h
kubeturbo                           Community Operators            2d16h
grafana-operator                    Community Operators            2d16h
postgresql-operator                 Community Operators            2d16h
t8c                                 Community Operators            2d16h
robin-operator                      Community Operators            2d16h
couchbase-enterprise                Community Operators            2d16h
ripsaw                              Community Operators            2d16h
eclipse-che                         Community Operators            2d16h
postgresql-operator-dev4devs-com    Community Operators            2d16h
wildfly                             Community Operators            2d16h
keda                                Community Operators            2d16h
awss3-operator-registry             Community Operators            2d16h
akka-cluster-operator               Community Operators            2d16h
kiali                               Community Operators            2d16h
postgres-operator                   Community Operators            2d16h
cos-bucket-operator                 Community Operators            2d16h
banzaicloud-kafka-operator          Community Operators            2d16h
storageos                           Community Operators            2d16h
enmasse                             Community Operators            2d16h
appranix                            Community Operators            2d16h
microcks                            Community Operators            2d16h
submariner                          Community Operators            2d16h
elastic-cloud-eck                   Community Operators            2d16h
metering-upstream                   Community Operators            2d16h
wavefront                           Community Operators            2d16h
spinnaker-operator                  Community Operators            2d16h
appsody-operator                    Community Operators            2d16h
synopsys                            Community Operators            2d16h
ibm-spectrum-scale-csi-operator     Community Operators            2d16h
rook-edgefs                         Community Operators            2d16h
openebs                             Community Operators            2d16h
cassandra-operator                  Community Operators            2d16h
redis-enterprise                    Community Operators            2d16h
kubevirt                            Community Operators            2d16h
composable-operator                 Community Operators            2d16h
event-streams-topic                 Community Operators            2d16h
multicloud-operators-subscription   Community Operators            2d16h
prometheus                          Community Operators            2d16h
atlasmap-operator                   Community Operators            2d16h
federatorai                         Community Operators            2d16h
etcd                                Community Operators            2d16h
minio-operator                      Community Operators            2d16h
hazelcast-enterprise                Community Operators            2d16h
rook-ceph                           Community Operators            2d16h
seldon-operator                     Community Operators            2d16h
ibmcloud-operator                   Community Operators            2d16h
hpa-operator                        Community Operators            2d16h
lib-bucket-provisioner              Community Operators            2d16h
argocd-operator-helm                Community Operators            2d16h
jaeger                              Community Operators            2d16h
oneagent                            Community Operators            2d16h
nexus-operator-hub                  Community Operators            2d16h
open-liberty                        Community Operators            2d16h
falco                               Community Operators            2d16h
halkyon                             Community Operators            2d16h
radanalytics-spark                  Community Operators            2d16h
infinispan                          Community Operators            2d16h
kubefed-operator                    Community Operators            2d16h
siddhi-operator                     Community Operators            2d16h
esindex-operator                    Community Operators            2d16h
yugabyte-operator                   Community Operators            2d16h
couchdb-operator                    Community Operators            2d16h
instana-agent                       Community Operators            2d16h
skydive-operator                    Community Operators            2d16h
percona-xtradb-cluster-operator     Community Operators            2d16h
api-operator                        Community Operators            2d16h
knative-serving-operator            Community Operators            2d16h
```

## Deploy the Operator using a subscription

- In order to install an operator, it is needed to have an `OperatorGroup` resource to define how to watch the operators to be deployed
  cluster wise or namespace scoped
```bash
kubectl apply -f operator-group.yml -n marketplace
operatorgroup.operators.coreos.com/operatorsgroup created
```

- To install the `openshift-pipelines-operator` operator, create a subscription
```bash
kubectl apply -f tekton-subscription.yml
```

- Verify the `Operator health`. So, Watch your Operator being deployed by OLM from the catalog source created by Operator Marketplace with the following command:
```bash
kubectl get clusterserviceversion -n marketplace
NAME                                  DISPLAY                        VERSION   REPLACES   PHASE
openshift-pipelines-operator.v0.8.2   OpenShift Pipelines Operator   0.8.2                Succeeded
```


## TO BE CHECKED

so your catalogsource either needs to be in the same namespace as your subscription OR needs to be in the global catalog namespace (which subscriptions will resolve in any namespace)

Charles Moulliard  2 minutes ago
So, the subscription should be then created within the same namespace as the catalogsource ?

Kevin Rizza  2 minutes ago
yes

Kevin Rizza  1 minute ago
if you're using an operatorsource for updates then you can do that by creating a catalogsourceconfig with targetNamespace set to the namespace you want your subscription in

Kevin Rizza  1 minute ago
or you can just edit your olm deployment to use marketplace as the global namespace
## Install to OLM on k8s

Steps to follow to install OLM on kubernetes cluster
https://github.com/operator-framework/community-operators/blob/master/docs/testing-operators.md#testing-operator-deployment-on-kubernetes

- ssh to the vm
- Execute the following bash script to install the OLM operator
```bash
./olm.sh 0.14.1
```

- Install the `Operator Marketplace` like also some `OperatorSource` into the cluster in the marketplace namespace:
```bash
git clone https://github.com/operator-framework/operator-marketplace.git
kubectl --validate=false apply -f operator-marketplace/deploy/upstream/
kubectl apply -f operator-marketplace/deploy/examples/community.operatorsource.cr.yaml
```

## Verify the catalog

- Check if the community catalog has been well deployed
```bash
kubectl get OperatorSource -A
NAMESPACE     NAME                           TYPE          ENDPOINT              REGISTRY                       DISPLAYNAME                    PUBLISHER   STATUS      MESSAGE                                       AGE
marketplace   community-operators            appregistry   https://quay.io/cnr   community-operators            Community Operators            Red Hat     Succeeded   The object has been successfully reconciled   14s
marketplace   upstream-community-operators   appregistry   https://quay.io/cnr   upstream-community-operators   Upstream Community Operators   Red Hat     Succeeded   The object has been successfully reconciled   28m
```

- Verify if the `CatalogSource` is created in the marketplace namespace:
```bash
kubectl get catalogsource -n marketplace
NAME                           DISPLAY                        TYPE   PUBLISHER   AGE
community-operators            Community Operators            grpc   Red Hat     103s
upstream-community-operators   Upstream Community Operators   grpc   Red Hat     30m
```

- Once the `OperatorSource` and `CatalogSource` are deployed, the following command can be used to list the available operators:
```bash
kubectl get opsrc community-operators -n marketplace -o=custom-columns=NAME:.metadata.name,PACKAGES:.status.packages
NAME                  PACKAGES
community-operators   awss3-operator-registry,lightbend-console-operator,special-resource-operator,camel-k,node-problem-detector,myvirtualdirectory,ibmcloud-operator,api-operator,enmasse,event-streams-topic,hawtio-operator,planetscale,openshift-pipelines-operator,knative-eventing-operator,atlasmap-operator,knative-kafka-operator,kubefed,smartgateway-operator,microsegmentation-operator,t8c,teiid,kubestone,federatorai,submariner,keycloak-operator,nexus-operator-hub,grafana-operator,service-binding-operator,container-security-operator,prometheus,hazelcast-enterprise,eclipse-che,apicurito,seldon-operator,spark-gcp,infinispan,opendatahub-operator,open-liberty,composable-operator,metering,strimzi-kafka-operator,akka-cluster-operator,argocd-operator-helm,jaeger,postgresql,iot-simulator,ibm-spectrum-scale-csi-operator,triggermesh,resource-locker-operator,kubeturbo,postgresql-operator-dev4devs-com,hyperfoil-bundle,aqua,opsmx-spinnaker-operator,radanalytics-spark,ripsaw,esindex-operator,ember-csi-operator,apicast-community-operator,traefikee-operator,knative-camel-operator,openebs,quay,lib-bucket-provisioner,kogito-operator,etcd,federation,syndesis,multicloud-operators-subscription,must-gather-operator,neuvector-community-operator,descheduler,cockroachdb,microcks,cert-utils-operator,kiali,halkyon,jenkins-operator,codeready-toolchain-operator,spinnaker-operator,twistlock,namespace-configuration-operator,maistraoperator,3scale-community-operator

kubectl get opsrc upstream-community-operators -n marketplace -o=custom-columns=NAME:.metadata.name,PACKAGES:.status.packages
NAME                           PACKAGES
upstream-community-operators   kong,jaeger,microcks,istio,twistlock,storageos,etcd,prometheus,planetscale,strimzi-kafka-operator,percona,synopsys,sysdig,spinnaker-operator,kubevirt,aws-service,couchbase-enterprise,aqua,federatorai,cockroachdb,instana-agent,camel-k,federation,kiali,hazelcast-enterprise,redis-enterprise,postgresql,oneagent,vault,infinispan,robin-operator,mongodb-enterprise,myvirtualdirectory,opsmx-spinnaker-operator,spark-gcp
```

## Deploy the Operator using a subscription

- Yo install the `Tekton` operator, a subscription is needed
```bash
kubectl apply -f tekton-subscription.yml
```
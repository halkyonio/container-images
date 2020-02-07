## Install OLM on k8s

Steps to follow to install OLM on kubernetes cluster
https://github.com/operator-framework/community-operators/blob/master/docs/testing-operators.md#testing-operator-deployment-on-kubernetes

- ssh to the vm
- Create the following bash script
```bash
cat <<EOF > olm.sh
#!/usr/bin/env bash

# This script is for installing OLM from a GitHub release

set -e

if [[ ${#@} -ne 1 ]]; then
    echo "Usage: $0 version"
    echo "* version: the github release version"
    exit 1
fi

release=$1
url=https://github.com/operator-framework/operator-lifecycle-manager/releases/download/${release}
namespace=olm

kubectl apply --validate=false -f ${url}/crds.yaml
kubectl apply -f ${url}/olm.yaml

# wait for deployments to be ready
kubectl rollout status -w deployment/olm-operator --namespace="${namespace}"
kubectl rollout status -w deployment/catalog-operator --namespace="${namespace}"

retries=50
until [[ $retries == 0 || $new_csv_phase == "Succeeded" ]]; do
    new_csv_phase=$(kubectl get csv -n "${namespace}" packageserver -o jsonpath='{.status.phase}' 2>/dev/null || echo "Waiting for CSV to appear")
    if [[ $new_csv_phase != "$csv_phase" ]]; then
        csv_phase=$new_csv_phase
        echo "Package server phase: $csv_phase"
    fi
    sleep 1
    retries=$((retries - 1))
done

if [ $retries == 0 ]; then
    echo "CSV \"packageserver\" failed to reach phase succeeded"
    exit 1
fi

kubectl rollout status -w deployment/packageserver --namespace="${namespace}"
EOF
```

- Change permissions and execute it
```bash
chmod +x ./olm.sh
./olm.sh 0.14.1
```

- Install the `Operator Marketplace` into the cluster in the marketplace namespace:
```bash
git clone https://github.com/operator-framework/operator-marketplace.git
kubectl --validate=false apply -f operator-marketplace/deploy/upstream/
```

- Check if the community catalog has been well deployed
```bash
kc get OperatorSource -A
NAMESPACE     NAME                           TYPE          ENDPOINT              REGISTRY                       DISPLAYNAME                    PUBLISHER   STATUS      MESSAGE                                       AGE
marketplace   upstream-community-operators   appregistry   https://quay.io/cnr   upstream-community-operators   Upstream Community Operators   Red Hat     Succeeded   The object has been successfully reconciled   8m10s
```

- Veirfy if the `CatalogSource` is created in the marketplace namespace:
```bash
kubectl get catalogsource -n marketplace
NAME                           DISPLAY                        TYPE   PUBLISHER   AGE
upstream-community-operators   Upstream Community Operators   grpc   Red Hat     9m14s
```

- Once the `OperatorSource` and `CatalogSource` are deployed, the following command can be used to list the available operators:
```bash
kubectl get opsrc upstream-community-operators -n marketplace -o=custom-columns=NAME:.metadata.name,PACKAGES:.status.packages
NAME                           PACKAGES
upstream-community-operators   kong,jaeger,microcks,istio,twistlock,storageos,etcd,prometheus,planetscale,strimzi-kafka-operator,percona,synopsys,sysdig,spinnaker-operator,kubevirt,aws-service,couchbase-enterprise,aqua,federatorai,cockroachdb,instana-agent,camel-k,federation,kiali,hazelcast-enterprise,redis-enterprise,postgresql,oneagent,vault,infinispan,robin-operator,mongodb-enterprise,myvirtualdirectory,opsmx-spinnaker-operator,spark-gcp
```
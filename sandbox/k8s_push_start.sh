#!/usr/bin/env bash

dir=$(dirname "$0")
project=hal
namespace=${3:-test}

pod_id=$(kubectl get pod -lapp=${project} -n ${namespace} | grep "Running" | awk '{print $1}')

echo "## Pushing Spring Boot jar file to the pod $pod_id ..."

#if [ $runtime = "nodejs" ]; then
#  cmd="run-node"
#  kubectl rsync ${dir}/../$project/ $pod_id:/opt/app-root/src/ --no-perms=true -n ${namespace}
#else
#fi

kubectl cp ${dir}/ $pod_id:/usr/src -n ${namespace}
kubectl exec $pod_id -n ${namespace} /var/lib/supervisord/bin/supervisord ctl start build

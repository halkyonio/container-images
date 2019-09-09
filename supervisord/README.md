## How to test it

To test the supervisord locally, build a new docker image and publish it
```bash
imagebuilder -t copy-supervisord:test .
TAG_ID=$(docker images -q copy-supervisord:test)
docker tag $TAG_ID quay.io/halkyonio/supervisord:test
docker push quay.io/halkyonio/supervisord:test
```

Next, execute the following command to deploy it on k8s/ocp
```bash
oc apply -f supervisord_pod.yml
```

Next, start/stop a command
```bash
COMMAND="appcheck"
pod_id=$(kubectl get pod -lapp=fruit-client | grep "Running" | awk '{print $1}')
kubectl exec $pod_id /var/lib/supervisord/bin/supervisord ctl start ${COMMAND}
```

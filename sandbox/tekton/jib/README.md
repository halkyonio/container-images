## How to play with it

### Locally

- See : https://github.com/GoogleContainerTools/jib/issues/2106
- Login in to quay.io
```bash
docker login -u="<USER>" -p="<PWD>" quay.io
```
- Instructions
```bash

git clone https://github.com/cmoulliard/hello-world-springboot.git && cd hello-world-springboot
mvn compile com.google.cloud.tools:jib-maven-plugin:2.0.0:build \
   -Djib.from.image=registry.redhat.io/redhat-openjdk-18/openjdk18-openshift \
   -Dimage=quay.io/<QUAY_ID>/<QUAY_REPO> \
   -Djib.from.auth.username=<RED_HAT_USERNAME> \
   -Djib.from.auth.password=<RED_HAT_PWD>
```

### Using Tekton

- To create the resources
```bash
oc new-project test
kc apply -f tekton/jib
```

- To clean up
```bash
kc delete task,taskrun,pipelineresource --all
```

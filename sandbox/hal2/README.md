## UBI image

- Fetch from brew the tar file, scp the file within the vm and import it within the ocp docker registry
```bash
tarName=ubi8-openjdk-11-15273-20200124145654.tar.xz
wget http://file.rdu.redhat.com/~jdowland/ubi8.2/$tarName

scp ubi8-openjdk-11-15273-20200124145654.tar.xz -i ~/.ssh/id_hetzner_snowdrop root@88.99.12.170:/tmp

ssh -i ~/.ssh/id_hetzner_snowdrop root@88.99.12.170
docker load -i $tarName
```
- Log on to the internal docker registry
```bash
docker login -u openshift -p $(oc whoami -t) 172.30.1.1:5000
```
- Next tag it to be able to use it within a namespace and push it
```bash
docker tag de3aac14333f 172.30.1.1:5000/test/ubi11
docker push 172.30.1.1:5000/test/ubi11
```

## Instructions

- Git clone locally the quarkus demo project
```bash
git clone https://github.com/cmoulliard/quarkus-demo.git
```
- Create the Dev's pod within the namespace `test` and expose the pod as service, route
```bash
kubectl apply -f deploy/
```

- To rsync the files to the pod, execute the following command and pass the pod name and project containing the code source (resolved locally) as parameters
```bash
./krsync quarkus quarkus-demo
```

- Find the pod id to execute the following command
```bash
POD_NAME=quarkus
NAMESPACE=test
POD_ID=$(kubectl get pod -lapp=${POD_NAME} -n ${NAMESPACE} | grep "Running" | awk '{print $1}')
echo $POD_ID
```

- Next, compile the project imported
```bash
kc exec $POD_ID -i -t -- mvn package -DskipTests=true -f /home/jboss/quarkus-demo/pom.xml -Dmaven.local.repo=/home/jboss/.m2/repository
```

- Finally, launch it 
```bash
kc exec $POD_ID -i -t -- java -jar /home/jboss/quarkus-demo/target/quarkus-rest-1.0-SNAPSHOT-runner.jar
2020-01-31 12:27:17,134 INFO  [io.quarkus] (main) quarkus-rest 1.0-SNAPSHOT (running on Quarkus 1.2.0.Final) started in 1.821s. Listening on: http://0.0.0.0:8080
2020-01-31 12:27:17,203 INFO  [io.quarkus] (main) Profile prod activated. 
2020-01-31 12:27:17,203 INFO  [io.quarkus] (main) Installed features: [cdi, resteasy]
```

- Test the `Hello` service nd curl it 
```bash
http http://quarkus-test.88.99.12.170.nip.io/hello/polite/charles
HTTP/1.1 200 OK
Cache-control: private
Content-Length: 20
Content-Type: text/plain;charset=UTF-8
Set-Cookie: b5b6e51386626d99db980a9be0a0bf0d=82691379466e8dcaa71f93f639063f7d; path=/; HttpOnly

Good evening,charles
```

- To build the container image using JIB Tool
```bash
kc exec $POD_ID -i -t -- mvn -f /home/jboss/quarkus-demo/pom.xml compile com.google.cloud.tools:jib-maven-plugin:2.0.0:build -Djib.from.image=registry.redhat.io/redhat-openjdk-18/openjdk18-openshift -Dimage=172.30.1.1:5000/test/quarkus-demo -Djib.from.auth.username=yyyy -Djib.from.auth.password=xxxx -Djib.container.mainClass=dev.snowdrop.HelloApplication -DsendCredentialsOverHttp=true -Djib.allowInsecureRegistries=true -Djava.util.logging.config.file=src/main/resources/jib-log.properties -Djib.serialize=true -Djib.console=plain
```

- To clean
```bash
kc delete svc,route,deployment,rolebinding,sa -n test --all
```

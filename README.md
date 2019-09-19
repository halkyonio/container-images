# Container Images

## Prerequisites

Be logged with the Quay registry
```bash
docker login -u <user> -p <pwd> quay.io
```

## Centos7 CircleCI image

Project to build a Centos7 image able to run on CircleCI.
```bash
cd circleci
docker build . -t quay.io/snowdrop/centos-circleci
docker push quay.io/snowdrop/centos-circleci
```

## Spring Boot maven s2i image

Project to build a jdk8 s2i image containing some spring boot starters dependencies. See `install_spring_boot_dependencies.sh` script
```bash
cd spring-boot-maven-s2i
docker build . -t quay.io/halkyonio/spring-boot-maven-s2i:latest
docker push quay.io/halkyonio/spring-boot-maven-s2i:latest
```
To build the snapshots, first build the different maven snapshot projects, next install a local HTTP Server
using your local m2 repository and define within the `settings.xml` the IP address of your server
```bash
npm install http-server -g
http-server ~/.m2/repository
```
and finally build the docker image tagged as `snapshot` 

```bash
docker build -t quay.io/halkyonio/spring-boot-maven-s2i:snapshot -f Dockerfile-snapshot .
docker push quay.io/halkyonio/spring-boot-maven-s2i:snapshot
```

**Remark**: You can change the version of Spring, Dekorate, ... to be packaged within the image using the `--build-arg KEY=VAL` property
  
## Supervisord image

**WARNING**: In order to build a multi-stages docker image, it is required to install [imagebuilder](https://github.com/openshift/imagebuilder) 
as the docker version packaged with MiniShift is too old and doesn't support such docker multi-stage option !

To build the `copy-supervisord` docker image containing the `go supervisord` application, then execute these instructions

```bash
cd supervisord
imagebuilder -t copy-supervisord:latest .
```
  
Tag the docker image and push it to `quay.io`

```bash
TAG_ID=$(docker images -q copy-supervisord:latest)
docker tag $TAG_ID quay.io/halkyonio/supervisord
docker push quay.io/halkyonio/supervisord
```
  
## OpenJDK S2I image

Due to permissions's issue to access the folder `/tmp/src`, the Red Hat OpenJDK1.8 S2I image must be enhanced to add the permission needed for the group `0`

Here is the snippet's part of the Dockerfile

```docker
USER root
RUN mkdir -p /tmp/src/target

RUN chgrp -R 0 /tmp/src/ && \
    chmod -R g+rw /tmp/src/
```

**IMPORTANT**: See this doc's [part](https://docs.openshift.org/latest/creating_images/guidelines.html#openshift-specific-guidelines) for more info about `Support Arbitrary User IDs`

Execute these commands to build the docker image and publish it on `Quay.io`
 
```bash
cd java-s2i
docker build -t spring-boot-http:latest .
TAG_ID=$(docker images -q spring-boot-http:latest)
docker tag $TAG_ID quay.io/halkyonio/spring-boot-s2i
docker tag $TAG_ID quay.io/halkyonio/openjdk8-s2i
docker push quay.io/halkyonio/spring-boot-s2i
docker push quay.io/halkyonio/openjdk8-s2i
```
## Maven Offline repo for Spring Boot

The purpose of this image is to extend the [Docker Maven JDK image](https://hub.docker.com/_/maven), to package the GAVs of Spring Boot 2.1.6, Dekorate 0.8.2
under the path `/tmp/artefacts` of the image in order to provide it as an internal maven cache for java maven build when you use the option `-Dmaven.repo.local=/tmp/.m2`

Example of multi-layers docker file able to use it 
```
## Stage 1 : build with maven builder image
FROM quay.io/halkyonio/spring-boot-offline-maven AS build
COPY . /usr/src
USER root

VOLUME /tmp/artefacts
RUN chown -R 1001:0 /usr/src
RUN mvn -f /usr/src/pom.xml clean package -Dmaven.repo.local=/tmp/artefacts

## Stage 2 : create the final image
FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift

USER root
WORKDIR /work/
COPY --from=build /usr/src/target/*.jar /work/application
RUN chown -R 1001:0 /work && chmod -R 775 /work

EXPOSE 8080
CMD ["./application"]
```

To build/push it, use the following commands
```bash
cd maven-offline-repo
docker build -t spring-boot-offline-maven .
TAG_ID=$(docker images -q spring-boot-offline-maven)
docker tag $TAG_ID quay.io/halkyonio/spring-boot-offline-maven
docker push quay.io/halkyonio/spring-boot-offline-maven
```

## Hal Maven JDK8 image

This image extends the maven jdk image `maven:3.6.2-jdk-8-slim`, includes an [offline
maven repo](maven-offline-repo) and needed bash scripts to perform: 

- `mvn -f /usr/src/${CONTEXTPATH}/${MODULEDIRNAME}/pom.xml ${MAVEN_ARGS} package -Dmaven.repo.local=/tmp/artefacts`
- `java -cp . -jar /usr/src/${CONTEXTPATH}/${MODULEDIRNAME}/target/*.jar`

ENV Vars available:

- `CONTEXTPATH`: path to access the directory of the maven project
- `MODULEDIRNAME`: Name of the maven module directory when your project is designed as a maven multi-modules structure
- `MAVEN_ARGS`: arguments to pass to the Maven command (e.g. -X)

To build the image
```bash
cd hal-mvn-jdk
docker build -t hal . 
TAG_ID=$(docker images -q hal)
docker tag $TAG_ID quay.io/halkyonio/hal-maven-jdk
docker push quay.io/halkyonio/hal-maven-jdk
```

To use it with an existing Spring Boot Maven project.
Pass as env `cmd` to specify either if you want to `build` the project or to launch `java`
```bash
docker run -it -v "$(pwd)":/usr/src -e CONTEXTPATH=. -e MODULEDIRNAME=. -e cmd=build hal
docker run -it -v "$(pwd)":/usr/src -e CONTEXTPATH=. -e MODULEDIRNAME=. -e cmd=run hal
```

You can also test it using k8s/ocp and a pod managed by a supervisord
```bash
oc delete -f ./sandbox/pod-hal.yml
oc apply -f ./sandbox/pod-hal.yml

kubectl cp pom.xml hal:/usr/src -n test
kubectl cp src hal:/usr/src -n test
kubectl exec hal -n test /var/lib/supervisord/bin/supervisord ctl start build
```

# Snowdrop Container Images

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
docker build . -t quay.io/halkyonio/spring-boot-maven-s2i
docker push quay.io/halkyonio/spring-boot-maven-s2i
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

**Remark**: Yiu can change the version of Spring, Dekorate, ... to be packaged within the image using the `--build-arg KEY=VAL` property
  
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
docker push quay.io/halkyonio/spring-boot-s2i
```
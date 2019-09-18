## Stage 1 : build with maven builder image
FROM quay.io/halkyonio/spring-boot-maven:snapshot AS build
COPY . /usr/src
USER root

ENV contexPath .
ENV moduleDirName .

RUN chown -R 1001:0 /usr/src
RUN mvn -f /usr/src/${contexPath}/${moduleDirName}/pom.xml package -Dmaven.repo.local=/tmp/artefacts

## Stage 2 : create the runtime image
FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift

USER root

ENV contexPath .
ENV moduleDirName .

WORKDIR /work/
COPY --from=build /usr/src/${contexPath}/${moduleDirName}/target/*.jar /deployments

EXPOSE 8080
CMD /usr/local/s2i/run

# https://spring.io/guides/gs/spring-boot-docker/
# FROM openjdk:8-jdk-alpine
# VOLUME /tmp
# ARG JAR_FILE
# COPY ${JAR_FILE} app.jar
# ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]

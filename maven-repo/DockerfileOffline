FROM maven:3.6.2-jdk-8-slim

USER root

ADD pom.xml pom.xml

RUN  mkdir -p /tmp/artefacts && \
     chmod a+x /tmp/artefacts && \
     chown -R 1001:0 /tmp/artefacts

# Problem with the official maven plugin --> Not all maven plugins downloaded !!
# RUN mvn dependency:go-offline -f pom.xml -Dmaven.repo.local=/tmp/artefacts
RUN mvn de.qaware.maven:go-offline-maven-plugin:1.2.1:resolve-dependencies -f pom.xml -Dmaven.repo.local=/tmp/artefacts

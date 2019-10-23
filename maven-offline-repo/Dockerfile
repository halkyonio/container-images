FROM hal-maven-jdk

USER root

ADD pom.xml pom.xml

# Problem with the official maven plugin --> Not all maven plugins downloaded !!
# RUN mvn dependency:go-offline -f pom.xml -Dmaven.repo.local=/tmp/artefacts
RUN mvn de.qaware.maven:go-offline-maven-plugin:1.2.1:resolve-dependencies -f pom.xml -Dmaven.repo.local=/tmp/artefacts

RUN rm pom.xml

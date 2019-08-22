FROM registry.redhat.io/redhat-openjdk-18/openjdk18-openshift

ARG SPRING_BOOT_VERSION=2.1.6.RELEASE
ARG JUNIT_VERSION=4.12
ARG FABRIC8_VERSION=3.5.40
ARG DEKORATE_VERSION="0.8.0"

ENV DEKORATE_GROUP=io.dekorate
ENV SPRING_BOOT_GROUP=org.springframework.boot
ENV SPRING_GROUP=org.springframework

COPY install_spring_boot_dependencies.sh /tmp/
COPY settings.xml /tmp/settings.xml
USER root
RUN chown 1001:0 /tmp/install_spring_boot_dependencies.sh && \
    chmod a+x /tmp/install_spring_boot_dependencies.sh && \
    mkdir -p /tmp/artifacts/m2 && \
    scl enable rh-maven35 /tmp/install_spring_boot_dependencies.sh && \
    chown -R 1001:0 /tmp/artifacts && \
    rm -f /tmp/install_spring_boot_dependencies.sh

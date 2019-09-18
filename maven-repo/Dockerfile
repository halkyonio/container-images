FROM maven:3.6.2-jdk-8-slim

ARG SPRING_BOOT_VERSION=2.1.6.RELEASE
ARG SNOWDROP_VERSION=2.1.6.SP3
ARG JUNIT_VERSION=4.12
ARG FABRIC8_VERSION=3.5.40
ARG DEKORATE_VERSION="0.8.2"

ENV DEKORATE_GROUP=io.dekorate
ENV SPRING_BOOT_GROUP=org.springframework.boot
ENV SPRING_GROUP=org.springframework
ENV SNOWDROP_GROUP=me.snowdrop

COPY install_spring_boot_dependencies.sh /tmp/
COPY settings.xml /tmp/settings.xml

USER root
RUN chown 1001:0 /tmp/install_spring_boot_dependencies.sh && \
    chmod a+x /tmp/install_spring_boot_dependencies.sh

RUN  mkdir -p /tmp/artefacts
RUN /bin/bash -c "source /tmp/install_spring_boot_dependencies.sh"

RUN chmod a+x /tmp/artefacts && \
    chown -R 1001:0 /tmp/artefacts

RUN rm -f /tmp/install_spring_boot_dependencies.sh

FROM		centos:7
MAINTAINER 	snowdrop "info@snowdrop.dev"

# Install needed software
USER root
RUN yum install -y epel-release && \
    yum install -y ansible git tar curl wget gcc sudo make yum-utils device-mapper-persistent-data lvm2 && \
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    yum install -y docker-ce kubectl kubelet && \
    yum clean all

# Solution to support systemd using docker and to avoid this error
# Docker: systemctl – Failed to get D-Bus connection: Operation not permitted
# https://goblincoding.com/2018/03/01/docker-systemctl-failed-to-get-d-bus-connection-operation-not-permitted/
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
  systemd-tmpfiles-setup.service ] || rm -f $i; done); \
  rm -f /lib/systemd/system/multi-user.target.wants/*;\
  rm -f /etc/systemd/system/*.wants/*;\
  rm -f /lib/systemd/system/local-fs.target.wants/*; \
  rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
  rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
  rm -f /lib/systemd/system/basic.target.wants/*;\
  rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

RUN sudo systemctl enable kubelet

# install jq
RUN JQ_URL="https://circle-downloads.s3.amazonaws.com/circleci-images/cache/linux-amd64/jq-latest" \
  && curl --silent --show-error --location --fail --retry 3 --output /usr/bin/jq $JQ_URL \
  && chmod +x /usr/bin/jq \
  && jq --version

# Configure circleci user
RUN groupadd -r circleci && useradd -r -d /home/circleci -m -g circleci circleci
RUN echo "%circleci        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

USER circleci


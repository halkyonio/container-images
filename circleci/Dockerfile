FROM		centos:7
MAINTAINER 	snowdrop "info@snowdrop.dev"

# Install needed software
USER root
RUN yum install -y epel-release && \
    yum install -y ansible git tar curl wget gcc sudo make yum-utils device-mapper-persistent-data lvm2 && \
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    yum install -y docker-ce && \
    yum clean all

# Install kubectl
COPY kubernetes.repo /etc/yum.repos.d/kubernetes.repo
RUN yum install -y kubectl

# Install go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | INSTALL_DIRECTORY=/usr/local/bin sh

# install jq
RUN JQ_URL="https://circle-downloads.s3.amazonaws.com/circleci-images/cache/linux-amd64/jq-latest" \
  && curl --silent --show-error --location --fail --retry 3 --output /usr/bin/jq $JQ_URL \
  && chmod +x /usr/bin/jq \
  && jq --version

# Configure circleci user
RUN groupadd -r circleci && useradd -r -d /home/circleci -m -g circleci circleci
RUN echo "%circleci        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

USER circleci

CMD ["/bin/sh"]


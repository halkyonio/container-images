FROM maven:3.6.2-jdk-8-slim

ADD build /usr/local/bin/
ADD run /usr/local/bin/

RUN mkdir -p /tmp/artefacts && chmod -R 777 /tmp/artefacts && chown -R 1001:0 /tmp/artefacts

RUN mkdir /deployments && chown 1001:0 /deployments && chmod a+x /deployments

RUN chmod +x /usr/local/bin/run && chmod +x /usr/local/bin/build
CMD ["/usr/local/bin/run"]
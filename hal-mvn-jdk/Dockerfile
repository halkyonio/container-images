FROM spring-boot-maven:snapshot

ADD *.sh /usr/local/bin/
WORKDIR /usr/local/bin
RUN chmod +x *.sh
CMD ["entrypoint.sh"]
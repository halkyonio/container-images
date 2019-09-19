#!/bin/bash

mvn -f /usr/src/${CONTEXTPATH}/${MODULEDIRNAME}/pom.xml ${MAVEN_ARGS} package -Dmaven.repo.local=/tmp/artefacts
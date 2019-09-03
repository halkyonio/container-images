#!/bin/sh
# Copyright (c) 2012-2017 Red Hat, Inc
# This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v2.0
# which is available at http://www.eclipse.org/legal/epl-2.0.html
#
# SPDX-License-Identifier: EPL-2.0

RED='\033[0;31m'
NC='\033[0m' # No Color
YELLOW='\033[0;33m'
BLUE='\033[0;34m'

function install {
  mvn -s /tmp/settings.xml dependency:get -Dartifact=$1 > /tmp/maven-$1.log
  if [ $? -eq 0 ]; then
    echo -e "🍻  ${YELLOW}$1 installed successfully ${NC}"
  else
    echo -e "☠️  ${RED}Unable to install $1 ${NC}"
    cat /tmp/maven-$1.log
    exit 1
  fi
}

echo -e "${BLUE}Installing Snowdrop ${SNOWDROP_VERSION} bom..."
install $SNOWDROP_GROUP:spring-boot-bom:$SNOWDROP_VERSION:pom
echo -e "${BLUE}Installing Spring Boot ${SPRING_BOOT_VERSION} bom, dependencies..."
install $SPRING_BOOT_GROUP:spring-boot-dependencies:$SPRING_BOOT_VERSION:pom
install $SPRING_BOOT_GROUP:spring-boot-starter-parent:$SPRING_BOOT_VERSION:pom
install $SPRING_BOOT_GROUP:spring-boot-starter-web:$SPRING_BOOT_VERSION
install $SPRING_BOOT_GROUP:spring-boot-starter-logging:$SPRING_BOOT_VERSION
install $SPRING_BOOT_GROUP:spring-boot-starter-tomcat:$SPRING_BOOT_VERSION
install $SPRING_BOOT_GROUP:spring-boot-starter-json:$SPRING_BOOT_VERSION
install $SPRING_BOOT_GROUP:spring-boot-starter-data-jpa:$SPRING_BOOT_VERSION
install $SPRING_BOOT_GROUP:spring-boot-starter-actuator:$SPRING_BOOT_VERSION
install $SPRING_BOOT_GROUP:spring-boot-starter-test:$SPRING_BOOT_VERSION
install $SPRING_BOOT_GROUP:spring-boot-loader-tools:$SPRING_BOOT_VERSION
install $SPRING_BOOT_GROUP:spring-boot-maven-plugin:$SPRING_BOOT_VERSION
install $SPRING_BOOT_GROUP:spring-boot-tools:$SPRING_BOOT_VERSION:pom
install $SPRING_BOOT_GROUP:spring-boot-maven-plugin:$SPRING_BOOT_VERSION
echo -e "${BLUE}Installing Dekorate ${$DEKORATE_VERSION} ..."
install $DEKORATE_GROUP:halkyon-spring-starter:$DEKORATE_VERSION
install $DEKORATE_GROUP:kubernetes-spring-starter:$DEKORATE_VERSION
install $DEKORATE_GROUP:openshift-spring-starter:$DEKORATE_VERSION
echo -e "${BLUE}Installing Tools such as Junit, Fabric8, ..."
install junit:junit:$JUNIT_VERSION
install io.fabric8:fabric8-maven-plugin:$FABRIC8_VERSION
echo -e "${BLUE}Spring Boot ${SPRING_BOOT_VERSION} dependencies installed ${NC}"
rm -Rf /tmp/maven-*
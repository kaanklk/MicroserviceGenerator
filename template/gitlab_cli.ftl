<#-- 


maven_settings_xml.ftl This file is part of MicroserviceGenerator.

Copyright (C) 2022 Kaan Kulak

MicroserviceGenerator is free software: you can redistribute it and/or modify it under the terms of the GNU 
General Public License as published by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.

MicroserviceGenerator is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with MicroserviceGenerator. 
If not, see <https://www.gnu.org/licenses/>.  



-->
variables:
  MAVEN_OPTS: "-Dhttps.protocols=TLSv1.2 -Dmaven.repo.local=$CI_PROJECT_DIR/.m2/repository -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=WARN -Dorg.slf4j.simpleLogger.showDateTime=true -Djava.awt.headless=true"
  MAVEN_CLI_OPTS: "-s maven_settings.xml --batch-mode --errors --fail-at-end --show-version -DinstallAtEnd=true -DdeployAtEnd=true -Djava.awt.headless=true"

image: maven:3.3.9-jdk-8

cache:
  paths:
    - .m2/repository

.verify: &verify
  stage: test
  script:
    - 'mvn $MAVEN_CLI_OPTS verify'
  except:
    variables:
      - $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

# Verify merge requests using JDK8
#verify:jdk8:
#  <<: *verify

stages:
  - build
  - test
  - package
  - deploy
#
services:
  - name: docker:dind

#
compile:
  stage: build
  script:
    - echo "Running compiler"
    - mvn -s maven_settings.xml clean compile
  artifacts:
    paths:
      - target/**
test:
  stage: test
  script:
    - echo "Testing"
    - mvn -s maven_settings.xml -P nexus surefire:test
  only:
    - /^develop/

sonar:
  stage: test
  script:
    - echo "Sonar checking"
    - mvn -s maven_settings.xml -P nexus -DskipTests=true compile
    - mvn -s maven_settings.xml -DskipTests=true -P sonar sonar:sonar
  only:
    - /^develop/

jar:
  stage: package
  script:
    - echo "Create & deploy packages"
    - mvn -s maven_settings.xml -DskipTests package deploy
  only:
    - /^uat|^master/

docker:
  stage: deploy
  script:
    - echo "Create & deploy docker images"
    - mvn -s maven_settings.xml -Ddeploy.issue=uat -DskipTests jib:build
  only:
    - /^uat|^master/

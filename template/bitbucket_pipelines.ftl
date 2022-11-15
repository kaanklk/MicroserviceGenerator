<#-- 


bitbucket_pipelines.ftl This file is part of MicroserviceGenerator.

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
image: maven:3.6-openjdk-11

definitions:
  steps:
    - step: &Init
        name: Initialize
        script:
          - echo "Initializing..."

    - step: &Compile
        name: Compile 
        artifacts:
          - target/**
        caches:
          - maven
        script:
          - echo "Running compiler"
          - mvn -s maven_settings.xml clean compile

    - step: &Testing
        name: Tests
        script:
          - echo "Running tests"
          - mvn -s maven_settings.xml surefire:test

    - step: &Package
        name: Package
        artifacts:
          - target/**
        caches:
          - maven
        script:
          - echo "Creating package"
          - mvn -s maven_settings.xml  -DskipTests deploy

    - step: &Deploying
        name: Deploy to Nexus repository
        script:
          - echo "Deploying to Nexus repository"
          - mvn -s maven_settings.xml -DskipTests  deploy

    - step: &Building-uat
        name: Building UAT docker image
        services:
          - docker
        script:
          - echo "Creating UAT Docker image"
          - mvn -s maven_settings.xml -DskipTests  package
          - mvn -s maven_settings.xml -Ddeploy.issue=uat -DskipTests  -P docker jib:build

    - step: &Building-prod
        name: Building Prod docker image
        services:
          - docker
        script:
          - echo "Creating Prod Docker image"
          - mvn -s maven_settings.xml -DskipTests  package
          - export buildtimestamp=$(date +%s)
          - mvn -s maven_settings.xml -Ddeploy.issue=prod -DskipTests  -P docker jib:build

    - step: &Sonar
        name: Sonar checking
        script:
          - echo "Running Sonarqube checking"
          - mvn -s maven_settings.xml -DskipTests  package
          - mvn -s maven_settings.xml sonar:sonar

pipelines:
  branches:
    bitbucket*:
      - step: *Init
      - step: *Package
      - step: *Testing
      - step: *Deploying
      - step: *Sonar
      - step: *Building-uat

    feature/*:
      - step: *Init
      - step: *Compile
      - step: *Testing

    develop:
      - step: *Init
      - step: *Package
      - step: *Testing
      - step: *Deploying
      - step: *Sonar

    uat:
      - step: *Init
      - step: *Package
      - step: *Building-uat

    master:
      - step: *Init
      - step: *Package
      - step: *Building-prod

  tags:
    release-*:
      - step: *Init
      - step: *Compile
      - step: *Building-uat
      - step: *Deploying

options:
  docker: true


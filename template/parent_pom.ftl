<#-- 


parent_pom.ftl This file is part of MicroserviceGenerator.

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
<?xml version="1.0" encoding="UTF-8"?>
<#assign map = YamlTool.parse(Documents.get(0))>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>${map.groupId}</groupId>
    <artifactId>${map.artifactId}-parent</artifactId>
    <version>${map.version}</version>
    <packaging>pom</packaging>

    <name>${map.name}</name>
    <description>${map.description}</description>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.7.0</version>
        <relativePath/>
    </parent>

    <properties>
        <!-- versions -->
        <#if map.java??>
            <#if map.java.version??>
            <java.version>${map.java.version}</java.version>
            </#if>
        </#if>
        <#if map.kotlin??>
            <#if map.kotlin.version??>
            <kotlin.version>${map.kotlin.version}</kotlin.version>
            </#if>
        </#if>
        <project.build.sourceEncoding>utf-8</project.build.sourceEncoding>
        <maven.compiler.target>8</maven.compiler.target>
        <maven.compiler.source>$\{java.version}</maven.compiler.source>
        <!-- constants -->
        <#if map.springProfiles??>
            <#list map.springProfiles as row>
                <${row.profile}.baseurl>${row.baseurl}</${row.profile}.baseurl>
                <${row.profile}.baseport>${row.baseport}</${row.profile}.baseport>
            </#list>
        </#if>
        <!-- global project constants -->
        <#if map.constants??>
            <#list map.constants as row>
            <${row.const}>${row.value}</${row.const}>
            </#list>
        </#if>
        <#if map.springProfiles??>
            <#list map.springProfiles as row>
            <db.${row.profile}.host>${row.db.host}</db.${row.profile}.host>
            <db.${row.profile}.port>${row.db.port}</db.${row.profile}.port>
            <db.${row.profile}.user>${row.db.user}</db.${row.profile}.user>
            <db.${row.profile}.password>${row.db.password}</db.${row.profile}.password> 
            <#list row.constants as rowconstants>
            <${row.profile}.${rowconstants.const}>${rowconstants.value}</${row.profile}.${rowconstants.const}>
            </#list>
            </#list>
        </#if>

        <#if map.repositories??>
        <#if map.repositories.docker??>
        <docker.repository>${map.repositories.docker.host}</docker.repository>
        <docker.baseimage>${map.repositories.docker.baseimage}</docker.baseimage>
        </#if>
        <#if map.repositories.source??>
        <source.repository>${map.repositories.source}</source.repository>
        </#if>
        </#if>
    </properties>

    <#if map.modules??>
    <modules>
    <#list map.modules as row>
        <module>../${row.artifactId}</module>
    </#list>
    </modules>
    </#if>

    <#if map.repositories??>
    <repositories>
        <#list map.repositories.repositories as repos>
        <repository>
            <id>${repos.repo}</id>
            <#if repos.repo == "mvnrepository">
            <url>https://mvnrepository.com</url>
            <name>Maven Repositories</name>
            <#elseif repos.repo == "springRelease">
            <url>https://repo.spring.io/release</url>
            <name>Spring Release</name>
            <#elseif repos.repo == "jcenter">
            <url>https://jcenter.bintray.org</url>
            <name>JCenter</name>
            <#else>
            <url>${repos.url}</url>
            <name>${repos.name}</name>
            </#if>
        </repository>
        </#list>
    </repositories>
    </#if>

    <#if map.repositories??>
    <distributionManagement>
    <#list map.repositories.repositories as repos>
    <#if repos.release?has_content><#if repos.release == "true"></#if>
        <repository>
            <id>${repos.repo}</id>
            <url>${repos.url}</url>
            <name>${repos.name}</name>
        </repository>
    </#if>
    <#if repos.snapshot?has_content><#if repos.snapshot == "true"></#if>
        <snapshotRepository>
            <id>${repos.repo}</id>
            <url>${repos.url}</url>
            <name>${repos.name}</name>
        </snapshotRepository>
    </#if>
    </#list>
    </#if>
    </distributionManagement>

    <#if map.modules??>
    <dependencyManagement>
        <dependencies>
    <#list map.modules as row>
        <#if row.dependencies??>
        <#list row.dependencies as deps>
            <dependency>
                <artifactId>${deps.dep}</artifactId>
                <#if deps.groupId??>
                <groupId>${deps.groupId}</groupId>
                </#if>
                <#if deps.version??>
                <version>${deps.version}</version>
                </#if>
            </dependency>
        </#list>
        </#if>
    </#list>
        </dependencies>
    </dependencyManagement>
    </#if>

    <build>
        <resources>
        <resource>
            <filtering>true</filtering>
            <directory>src/main/resources</directory>
            <includes>
                <include>**/*.properties</include>
                <include>**/*.xml</include>
                <include>**/*.yml</include>
                <include>**/*.yaml</include>
                <include>**/*.sql</include>
                <include>**/*.pem</include>
                <include>**/*.ftlh</include>
            </includes>
        </resource>
        <resource>
            <filtering>false</filtering>
            <directory>src/main/resources</directory>
            <includes>
                <include>**/*.jasper</include>
                <include>**/*.jrxml</include>
                <include>**/*.png</include>
            </includes>
        </resource>
    </resources>

    <testResources>
        <testResource>
            <directory>src/test/resources</directory>
            <filtering>true</filtering>
            <includes>
                <include>**/*.yml</include>
                <include>**/*.yaml</include>
            </includes>
        </testResource>
    </testResources>

    <#if map.modules??>
    <pluginManagement>
        <plugins>
        <#list map.modules as row>
            <#if row.plugins??>
            <#list row.plugins as plugins>
            <plugin>
                <artifactId>${plugins.plugin}</artifactId>
            </plugin>
            </#list>
            </#if>
        </#list>
        </plugins>
    </pluginManagement>
    </#if>

    </build>

    <scm>
        <connection>scm:git:https://$\{source.repository}/$\{project.artifactId}.git</connection>
        <url>https://$\{source.repository}/$\{project.artifactId}</url>
        <developerConnection>scm:git:https://$\{source.repository}/$\{project.artifactId}.git
        </developerConnection>
    </scm>

    <#if map.developers??>
    <contributors>
        <#list map.developers as row>
        <contributor>
            <name>${row.name}</name>
            <email>${row.email}</email>
            <#if row.roles??>
            <#list row.roles as role>
            <roles>
                <role>${role}</role>
            </roles>
            </#list>
            </#if>
        </contributor>
        </#list> 
    </contributors>
    </#if>

</project>
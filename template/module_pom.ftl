<#-- 


module_pom.ftl This file is part of MicroserviceGenerator.

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

    <artifactId>${map.artifactId}</artifactId>
    <version>${map.version}</version>
    <groupId>${map.groupId}</groupId>

    <packaging>pom</packaging>

    <#if map.modules??>
    <modules>
        <#list map.modules as row>
        <module>${row.artifactId}</module>
        </#list>
    </modules>
    </#if>

    <#if map.modules??>
    <dependencies>
        <#list map.modules as row>
            <#list row.dependencies as dependencyrow>
            <dependency>
                <artifactId>${dependencyrow.dep}</artifactId>
                <groupId>${dependencyrow.groupId}</groupId>
                <version>${dependencyrow.version}</version>
            </dependency>
            </#list>
        </#list>
    </dependencies>
    </#if>

    <#if map.dependencies??>
    <dependencies>
        <#list map.dependencies as row>
        <dependency>
            <artifactId>${row.dep}</artifactId>
            <groupId>${row.groupId}</groupId>
            <version>${row.version}</version>
        </dependency>
        </#list>
    </dependencies>
    </#if>

    <#if map.modules??>
    <build>
        <sourceDirectory>${'${'}project.basedir${'}'}/src/main/java</sourceDirectory>
        <testSourceDirectory>${'${'}project.basedir${'}'}/src/test/java</testSourceDirectory>
        <plugins>
            <#list map.modules as row>
                <#list row.plugins as pluginrow>
                <plugin>
                    <artifactId>${pluginrow.plugin}</artifactId>
                </plugin>
                </#list>
            </#list>
        </plugins>
    </build>
    </#if>

    <#if map.plugins??>
    <build>
        <sourceDirectory>${'${'}project.basedir${'}'}/src/main/java</sourceDirectory>
        <testSourceDirectory>${'${'}project.basedir${'}'}/src/test/java</testSourceDirectory>
        <plugins>
            <#list map.plugins as row>
            <plugin>
                <artifactId>${row.plugin}</artifactId>
            </plugin>
            </#list>
        </plugins>
    </build>
    </#if>

    <#if map.developers??>
    <developers>
        <#list map.developers as row>
        <developer>
            <id>${row.developer}</id>
            <roles>
            <#list row.roles as rowroles> 
                <role>${rowroles.role}</role>
            </#list>
            </roles>
        </developer>
        </#list>
    </developers>
    </#if>

    <scm>
        <connection>scm:git:https://${'${'}source.repository${'}'}/${'${'}project.artifactId${'}'}.git</connection>
        <url>https://${'${'}source.repository${'}'}/${'${'}project.artifactId${'}'}</url>
        <developerConnection>scm:git:https://${'${'}source.repository${'}'}/${'${'}project.artifactId${'}'}.git
        </developerConnection>
    </scm>

</project>
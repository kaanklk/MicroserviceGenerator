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
<?xml version="1.0" encoding="UTF-8"?>
<#assign map = YamlTool.parse(Documents.get(0))>
<settings>
    <localRepository>$/{user.home}/.m2/repository</localRepository>
    <interactiveMode>true</interactiveMode>
    <usePluginRegistry>false</usePluginRegistry>

    <#if map.profiles??>
    <profiles>
        <#list map.profiles as profiles>
            <profile>
                <id>${profiles.profile}></id>
                <#if profiles.profile != "sonar">
                    <#if profiles.repositories??>
                    <repositories>
                        <#list profiles.repositories as repos>
                                <#if repos.repo == "jcenter">
                                <repository>
                                    <id>jcenter</id>
                                    <name>JCenter repository</name>
                                    <url>http://jcenter.bintray.com</url>
                                </repository>
                                <#elseif repos.repo == "mvnrepository">
                                <repository>
                                    <id>mvnrepository</id>
                                    <name>Maven central repository</name>
                                    <url>https://mvnrepository.com</url>
                                </repository>
                                <#elseif repos.repo == "springrelease">
                                <repository>
                                    <id>springRelease</id>
                                    <name>Spring Releases repository</name>
                                    <url>https://repo.spring.io/release</url>
                                </repository>
                                <#else>
                                    <#continue>
                                </#if>
                        </#list>
                    <repositories>
                    </#if>
                <#elseif profiles.profile == "sonar">
                <id>sonar</id>
                <properties>
                    <sonar.host.url></sonar.host.url>
                    <sonar.login></sonar.login>
                </properties>
                <activation>
                    <activeByDefault>${profiles.activeByDefault}</activeByDefault>
                </activation>
                </#if>
            </profile>
        </#list>
    </profiles>
    </#if>

    <activeProfiles>
        <activeProfile>mvnrepository</activeProfile>
    </activeProfiles>

    <servers>
    </servers>

</settings>
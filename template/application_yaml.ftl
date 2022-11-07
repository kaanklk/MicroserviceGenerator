<#-- 


application_yaml.ftl This file is part of MicroserviceGenerator.

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
<#assign map = YamlTool.parse(Documents.get(0))>
server:
    port: @port.collector@
    servlet:
        use-forward-headers: true

spring:
    application:
        name: @project.artifactId@
    <#if map.database??>
    datasource:
        <#if map.database.type == "postgres">
        driverClassName: org.postgresql.Driver
        </#if>
    jpa:
        <#if map.database.type == "postgres">
        databasePlatform: org.hibernate.dialect.PostgreSQL82Dialect
        </#if>
        properties:
            hibernate:
                type:
                    descriptor:
                        sql:
                            level: ERROR
                enable_lazy_load_no_trans: true
                temp:
                    useJdbcMetadataDefaults: false
                jdbc:
                    lob:
                        nonContextualCreation: true
        show-sql: false
    </#if>
logging:
    level:
        org:
            springframework: INFO
            hibernate: INFO

management:
    endpoints:
        enabled-by-default: true
        web:
            exposure:
                include: "*"
                exclude:
        metrics:
            enabled: true
        prometheus:
            enabled:true
    endpoint:
        info:
            enabled: true
        shutdown:
            enabled: true

build:
    version: @project.version@

mail:
    host: @mail.host@
    port: @mail.port@
    password: @mail.password@
    sender: @mail.sender@
    admin: @admin.mail@

<#list map.constants as constants>
${constants.const}: ${constants.value}
</#list>
---
    <#if map.springProfiles??>
    <#list map.springProfiles as profiles>
    spring:
    profiles: ${profiles.profile}
        datasource: 
        url: ${profiles.baseurl}
        username: ${profiles.db.user}
        password: ${profiles.db.password}
        eureka:
        client:
        serviceUrl: 
        defaultZone: ${profiles.eureka}
        <#list profiles.constants as constants>
            ${constants.const}: ${constants.value}
        </#list>
    </#list>
    </#if>

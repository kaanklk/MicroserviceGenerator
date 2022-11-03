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

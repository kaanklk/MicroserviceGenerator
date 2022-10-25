<#ftl output_format="plainText">
<#assign map = YamlTool.parse(Documents.get(0))>

<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <artifactId>${map.artifactId}</artifactId>
    <version>${map.version}</version>

    <packaging>jar</packaging>

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
        </dependency>
        </#list>
    </dependencies>
    </#if>

    <#if map.modules??>
    <plugins>
        <#list map.modules as row>
            <#list row.plugins as pluginrow>
            <plugin>
                <artifactId>${pluginrow.plugin}</artifactId>
            </plugin>
            </#list>
        </#list>
    </plugins>
    </#if>

    <#if map.plugins??>
    <plugins>
        <#list map.plugins as row>
        <plugin>
            <artifactId>${row.plugin}</artifactId>
        </plugin>
        </#list>
    </plugins>
    </#if>


    <#if map.developers??>
    <developers>
        <#list map.developers as row>
        <developer>
            <id>${row.developer}</id>
            <#list row.roles as rowroles> 
            <role>${rowroles.role}</role>
            </#list>
        </developer>
        </#list>
    </developers>
    </#if>

    <scm>
        <connection>scm:git:https://$\{source.repository}/$\{project.artifactId}.git</connection>
        <url>https://$\{source.repository}/$\{project.artifactId}</url>
        <developerConnection>scm:git:https://$\{source.repository}/$\{project.artifactId}.git
        </developerConnection>
    </scm>

</project>
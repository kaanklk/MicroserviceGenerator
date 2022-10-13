<#ftl output_format="plainText">
<#assign map = YamlTool.parse(Documents.get(0))>

<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>${map.springVersion}</version>
		<relativePath/> <!-- lookup parent from repository -->
	</parent>
	
    <groupId>${map.groupId}</groupId>
    <artifactId>${map.artifactId}/></artifactId>
    <version>${map.version}</version>
    <name>${map.name}</name>
    <description>${map.description}</description>
    <packaging>${map.packaging}</packaging>

    <modules>
        <#list map.modules as moduletype,key >
			<module>${moduletype}</module>
		</#list>
    </modules>

</project>
	

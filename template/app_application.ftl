<#-- 


app_application.ftl This file is part of MicroserviceGenerator.

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
<#assign artifactId = map.artifactId?capitalize>
package ${map.groupId}.<#if map.artifactId?contains("-")><#list map.artifactId?split("-") as x>${x}</#list><#else>${map.artifactId}</#if>;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class <#if artifactId?contains("-")><#list artifactId?split("-") as x>${x}</#list><#else>${artifactId}</#if>Application {

	public static void main(String[] args) {
		SpringApplication.run(<#if artifactId?contains("-")><#list artifactId?split("-") as x>${x}</#list><#else>${artifactId}</#if>Application.class, args);
	}

}

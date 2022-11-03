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

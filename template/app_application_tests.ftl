<#assign map = YamlTool.parse(Documents.get(0))>
<#assign artifactId = map.artifactId?capitalize>
package ${map.groupId}.<#if map.artifactId?contains("-")><#list map.artifactId?split("-") as x>${x}</#list><#else>${map.artifactId}</#if>;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class <#if artifactId?contains("-")><#list artifactId?split("-") as x>${x}</#list><#else>${artifactId}</#if>ApplicationTests {

	@Test
	void contextLoads() {
	}

}

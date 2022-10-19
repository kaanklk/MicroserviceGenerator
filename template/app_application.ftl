<#assign map = YamlTool.parse(Documents.get(0))>
package ${map.groupId}.${map.artifactId};

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class ${map.artifactId}Application {

	public static void main(String[] args) {
		SpringApplication.run(${map.artifactId}Application.class, args);
	}

}

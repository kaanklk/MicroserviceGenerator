#
# create_module.py This file is part of MicroserviceGenerator.
#
# Copyright (C) 2022 Kaan Kulak
#
# MicroserviceGenerator is free software: you can redistribute it and/or modify it under the terms of the GNU 
# General Public License as published by the Free Software Foundation, either version 3 of the License, 
# or (at your option) any later version.
#
# MicroserviceGenerator is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
# without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with MicroserviceGenerator. 
# If not, see <https://www.gnu.org/licenses/>.  
#

import json
import os
from typing import final
import yaml
import requests
import re

freemarker = "freemarker-cli -t"

# Start generating modules
def cmodule(templatepath,outputpath,root,configpath): 

    groupid = root["groupId"].split(".")
    modules = root["modules"]
    groupidname = root["groupId"]
    jars = rjarsconf(configpath)

    os.chdir(configpath.as_posix())
    
    ujars(root,jars)

    gparentmod(templatepath,outputpath,root,configpath)

    gmodules(templatepath, outputpath, groupid, modules, groupidname,configpath)

#reading moduleconfig
def rmoduleconf(moduleconf):
    try:
        with open(moduleconf,'r') as mconf:
            mroot = yaml.safe_load(mconf)
            mconf.close()
        return mroot
    except Exception as e:
        print(e)

# reading jarsconfig
def rjarsconf(configpath):
    try:
        with open(configpath.joinpath("jars.yaml") ,"r") as jconf:
            jars = yaml.safe_load(jconf)
            jconf.close()
        return jars
    except Exception as e:
        print(e)

def fndlatestversion(group, artifact):
     rq = "https://search.maven.org/solrsearch/select?q=g:" + group +"+AND+a:" + artifact + "&wt=json"
     response = requests.get(rq)
     if response.status_code != 200:
         return "UNKNOWN"
     info = json.loads(response.text)
     if len(info['response']['docs']) > 0:
         return info['response']['docs'][0]['latestVersion']
     return "UNKNOWN"

def gmodules(templatepath, outputpath, groupid, modules, groupidname,configpath):

    print("Generating modules...")

    submoduleflag = False

    for module in modules:
        os.chdir(outputpath.as_posix())
        os.mkdir(module["artifactId"])
        os.chdir(module["artifactId"])
        try:
            f = open("moduleconfig.yml","a")
            f.write(yaml.dump(module))
            f.write(yaml.dump({"groupId" : groupidname}))
            f.close()

            os.system(freemarker+str(templatepath.as_posix())+"/gitlab_cli.ftl "+
                        configpath.as_posix()+"/config.yaml"+" -o"+" .gitlab_ci.yaml")
            
            os.system(freemarker+str(templatepath.as_posix())+"/bitbucket_pipelines.ftl "+
                        configpath.as_posix()+"/config.yaml"+" -o"+" bitbucket-pipelines.yaml")
            
            os.system(freemarker+str(templatepath.as_posix())+"/maven_settings_xml.ftl "+
                        configpath.as_posix()+"/config.yaml"+" -o"+" maven_settings.xml")

            if submoduleflag == False:
                os.system(freemarker+str(templatepath.as_posix())+"/module_pom.ftl "+
                "moduleconfig.yml "+"-o pom.xml")
            mroot = rmoduleconf("moduleconfig.yml")
            if(mroot.get("modules") != None):
                submoduleflag = True
                for submodule in mroot["modules"]:
                    gsubmodule(templatepath, outputpath, groupid, groupidname, module, submodule,configpath)
            else:
                submoduleflag = False

        except Exception as e:
            print(e)

        if submoduleflag != True:
            gmodstr(templatepath, mroot, groupid, module, configpath)

        os.chdir(outputpath.as_posix())
    
    print("Modules are generated successfully!")

def gsubmodule(templatepath, outputpath, groupid, groupidname, module, submodule,configpath):
    os.mkdir(submodule["artifactId"])
    os.chdir(submodule["artifactId"])
    try:
        f = open("moduleconfig.yml","a")
        f.write(yaml.dump(submodule))
        f.write(yaml.dump({"groupId" : groupidname}))
        f.close()
        os.system(freemarker+str(templatepath.as_posix())+"/module_pom.ftl "+
                        "moduleconfig.yml "+"-o pom.xml")

        smroot = rmoduleconf("moduleconfig.yml")

    except Exception as e:
        print(e)
    
    gmodstr(templatepath,smroot,groupid,submodule,configpath)

    os.chdir(outputpath.as_posix())
    os.chdir(module["artifactId"])

def gparentmod(templatepath, outputpath, root, configpath):

    print("Generating parent module...")

    if(os.path.exists(outputpath) != True):
        os.mkdir(outputpath.as_posix())

    os.chdir(outputpath.as_posix())
    os.mkdir(root["artifactId"]+"-parent")
    os.chdir(root["artifactId"]+"-parent")

    os.system(freemarker+str(templatepath.as_posix())+"/parent_pom.ftl "+
                        configpath.as_posix()+"/uconfig.yaml"+" -o"+" pom.xml")

def ujars(root, jars):

    print("Updating jars...")
    
    ujardependencies(root, jars)

    ujarplugins(root, jars)

    with open("uconfig.yaml","w") as f:
        f.write(yaml.dump(root))
        f.close()

def ujarplugins(root, jars):
    for module in root["modules"]:
        if module.get("plugins") != None:
            for plugin in module["plugins"]:
                for plugins in jars["plugins"]:
                    if plugin["plugin"] == plugins["artifactId"]:
                        plugin["groupId"] = plugins["groupId"]
                        if plugins.get("version") != None and plugins["version"] == "latest":
                            plugin["version"] = fndlatestversion(plugin["groupId"],plugin["plugin"])
        else:
            if module.get("modules") != None:
                for submodule in module["modules"]:
                    for plugin in submodule["plugins"]:
                        for plugins in jars["plugins"]:
                            if plugin["plugin"] == plugins["artifactId"]:
                                plugin["groupId"] = plugins["groupId"]
                                if plugins.get("version") != None and plugins["version"] == "latest":
                                    plugin["version"] = fndlatestversion(plugin["groupId"],plugin["plugin"])

def ujardependencies(root, jars):
    for module in root["modules"]:
        if module.get("dependencies") != None:
            for dependency in module["dependencies"]:
                for artifacts in jars["artifacts"]:
                    if dependency["dep"] == artifacts["artifactId"]:
                        dependency["groupId"] = artifacts["groupId"]
                        if artifacts.get("version") != None and artifacts["version"] == "latest":
                            dependency["version"] = fndlatestversion(dependency["groupId"],dependency["dep"])
        else:
            for submodule in module["modules"]:
                for dependency in submodule["dependencies"]:
                    for artifacts in jars["artifacts"]:
                        if dependency["dep"] == artifacts["artifactId"]:
                            dependency["groupId"] = artifacts["groupId"]
                            if artifacts.get("version") != None and artifacts["version"] == "latest":
                                dependency["version"] = fndlatestversion(dependency["groupId"],dependency["dep"])

# Generate module stucture and application code
def gmodstr(templatepath, root, groupid, module,configpath):
    istest = False

    module_cwd = os.getcwd()

    if root.get("port") != None:
        os.makedirs("./src/main/resources")
        os.chdir("./src/main/resources")
        os.system(freemarker+str(templatepath.as_posix())+"/application_yaml.ftl "+
                        configpath.as_posix()+"/config.yaml"+" -o"+" application.yaml")
        os.chdir("../..")
        os.makedirs("test/java")
        os.chdir("test/java")

        istest = True
        gengroup(templatepath, groupid, module, module_cwd,istest)
        istest = False

        os.chdir(module_cwd+"/src/main")
        os.mkdir("java")
        os.chdir("java")

    else:
        os.makedirs("./src/main/java")
        os.chdir("./src/main/java")

    gengroup(templatepath, groupid, module, module_cwd,istest)

def gengroup(templatepath, groupid, module, module_cwd,istest):

    for group in groupid:
        os.mkdir(group)
        os.chdir(group)
        if(group == groupid[-1]):
            os.mkdir(module["artifactId"])
            os.chdir(module["artifactId"])
            appname = re.sub(r'[^A-Za-z]','',module["artifactId"]).capitalize()
            if istest == False:
                os.system(freemarker+str(templatepath.as_posix())+"/app_application.ftl "+
                        module_cwd+"/moduleconfig.yml "+"-o "+appname+"Application.java")
            else:
                os.system(freemarker+str(templatepath.as_posix())+"/app_application_tests.ftl "+
                        module_cwd+"/moduleconfig.yml "+"-o "+appname+"ApplicationTests.java")
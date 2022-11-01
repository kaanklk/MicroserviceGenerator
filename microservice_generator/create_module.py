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
import yaml
import requests

freemarker = "freemarker-cli -t"

# Start generating modules
def cmodule(templatepath,outputpath,root,configpath): 

    print("Creating modules...")

    groupid = root["groupId"].split(".")
    modules = root["modules"]
    groupidname = root["groupId"]
    jars = rjarsconf(configpath)

    gparentmod(templatepath,outputpath,root,configpath,jars)
    gmodules(templatepath, outputpath, root, groupid, modules, groupidname)

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

def gmodules(templatepath, outputpath, root, groupid, modules, groupidname):

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


            if submoduleflag == False:
                os.system(freemarker+str(templatepath.as_posix())+"/module_pom.ftl "+
                "moduleconfig.yml "+"-o pom.xml")
            mroot = rmoduleconf("moduleconfig.yml")
            if(mroot.get("modules") != None):
                submoduleflag = True
                for submodule in mroot["modules"]:
                    gsubmodule(templatepath, outputpath, groupid, groupidname, module, mroot, submodule)
            else:
                submoduleflag = False

        except Exception as e:
            print(e)

        if submoduleflag != True:
            gmodstr(templatepath, root, groupid, module)

        os.chdir(outputpath.as_posix())
    
    print("Modules are generated successfully!")

def gsubmodule(templatepath, outputpath, groupid, groupidname, module, mroot, submodule):
    os.mkdir(submodule["artifactId"])
    os.chdir(submodule["artifactId"])
    try:
        f = open("moduleconf.yml","a")
        f.write(yaml.dump(submodule))
        f.write(yaml.dump({"groupId" : groupidname}))
        f.close()
        os.system(freemarker+str(templatepath.as_posix())+"/module_pom.ftl "+
                        "moduleconf.yml "+"-o pom.xml")
    except Exception as e:
        print(e)
                            
    gmodstr(templatepath,mroot,groupid,submodule)

    os.chdir(outputpath.as_posix())
    os.chdir(module["artifactId"])

def gparentmod(templatepath, outputpath, root, configpath,jars):

    if(os.path.exists(outputpath) != True):
        os.mkdir(outputpath.as_posix())
    
    os.chdir(outputpath.as_posix())
    os.mkdir(root["artifactId"]+"-parent")
    os.chdir(root["artifactId"]+"-parent")

    ujars(root, jars)

    os.system(freemarker+str(templatepath.as_posix())+"/parent_pom.ftl "+
                        configpath.as_posix()+" -o"+" pom.xml")

def ujars(root, jars):

    print("Updating jars...")

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
def gmodstr(templatepath, root, groupid, module):
    module_cwd = os.getcwd()
        
    if(root.get("kotlin") != None):
        os.makedirs("./src/main/kotlin")
        os.chdir("./src/main/kotlin")
    else:
        os.makedirs("./src/main/java")
        os.chdir("./src/main/java")

    for group in groupid:
        os.mkdir(group)
        os.chdir(group)
        if(group == groupid[-1]):
            os.mkdir(module["artifactId"])
            os.chdir(module["artifactId"])
            if (root.get("java") != None):
                os.system(freemarker+str(templatepath.as_posix())+"/app_application.ftl "+
                    module_cwd+"/moduleconfig.yml "+"-o "+module["artifactId"]+"Application.java")
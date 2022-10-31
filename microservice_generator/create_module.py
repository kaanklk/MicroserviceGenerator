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


from ensurepip import version
from operator import index, mod
import os
import yaml

freemarker = "freemarker-cli -t"

# Start generating modules
def cmodule(templatepath,outputpath,root,configpath): 

    print("Creating modules...")

    groupid = root["groupId"].split(".")
    modules = root["modules"]
    groupidname = root["groupId"]

    gparentmod(templatepath,outputpath,root,configpath)
    gmodules(templatepath, outputpath, root, groupid, modules, groupidname,configpath)

#reading moduleconfig
def rmoduleconf():
    try:
        with open("moduleconfig.yml",'r') as mconf:
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

# update module conf
def umoduleconf(jars):
    print("Updating jars...")
    mroot = rmoduleconf()
    for artifacts in jars["artifacts"]:
        for dependencies  in mroot["dependencies"]:
            if dependencies["dep"] == artifacts["artifactId"]:
                dependencies["groupId"] = artifacts["groupId"]

    os.remove("moduleconfig.yml")
    f = open("moduleconfig.yml","w")
    f.write(yaml.dump(mroot))
    f.close()

def gmodules(templatepath, outputpath, root, groupid, modules, groupidname,configpath):

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

            # updating jars
            jars = rjarsconf(configpath)
            umoduleconf(jars)

            if submoduleflag == False:
                os.system(freemarker+str(templatepath.as_posix())+"/module_pom.ftl "+
                "moduleconfig.yml "+"-o pom.xml")
            mroot = rmoduleconf()
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

def gparentmod(templatepath, outputpath, root, configpath):

    if(os.path.exists(outputpath) != True):
        os.mkdir(outputpath.as_posix())
    
    os.chdir(outputpath.as_posix())
    os.mkdir(root["artifactId"]+"-parent")
    os.chdir(root["artifactId"]+"-parent")
    os.system(freemarker+str(templatepath.as_posix())+"/parent_pom.ftl "+
                        configpath.as_posix()+" -o"+" pom.xml")
    

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
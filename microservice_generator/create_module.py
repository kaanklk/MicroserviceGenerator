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


from operator import mod
import os
import yaml


def create_module(templatepath,outputpath,root): 

    print("Creating modules...")

    groupid = root["groupId"].split(".")
    modules = root["modules"]

    if(os.path.exists(outputpath) != True):
        os.mkdir(outputpath.as_posix())
    os.chdir(outputpath.as_posix())

    for module in modules:
        os.mkdir(module["artifactId"])
        os.chdir(module["artifactId"])
        try:
            f = open("moduleconfig.yml","a")
            f.write(yaml.dump(module))
            f.close()
            os.system("freemarker-cli -t "+str(templatepath.as_posix())+"/module_pom.ftl "+"moduleconfig.yml "+"-o pom.xml")
            #os.remove("moduleconfig.yml")
        except Exception as e:
            print(e)
        
        if (root.get("java") != None):
            os.makedirs("./src/main/java")
            os.chdir("./src/main/java")
        elif(root.get("kotlin") != None):
            os.makedirs("./src/main/kotlin")
            os.chdir("./src/main/kotlin")

        for group in groupid:
            os.mkdir(group)
            os.chdir(group)
            if(group == groupid[-1]):
                os.mkdir(module["artifactId"])

        os.chdir(outputpath.as_posix())
    
    print("Modules are generated successfully!")

  



        


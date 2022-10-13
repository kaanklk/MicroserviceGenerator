#
# microservicegen.py This file is part of MicroserviceGenerator.
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

import argparse
import os
import yaml
from pathlib import Path
import traceback

def create_skeleton(configpath, templatepath, outputpath,data):
    try:
        os.mkdir(outputpath)
        os.chdir(outputpath)
    except Exception:
        print("Failed to create output directory!")
        print(traceback.format_exc())

    try:
        groupid = data["groupId"].split(".")
    except Exception:
        print("Please determine groupId properly in config file!")
        print(traceback.format_exc())

    
    try:
        print("Generating folder structure...")
        for module in data["modules"]:
            os.makedirs(str(outputpath.absolute())+"/%s/src/main/java/" % module)
            os.makedirs(str(outputpath.absolute())+"/%s/src/main/resources/" % module)
            os.makedirs(str(outputpath.absolute())+"/%s/src/test/java/" % module)
            for type in {"main","test"}:
                if type == "main":
                    os.chdir(str(outputpath.absolute())+"/%s/src/main/java/" % module)
                    for group in groupid:
                        os.mkdir(group)
                        os.chdir(group)
                elif type == "test":
                    os.chdir(str(outputpath.absolute())+"/%s/src/test/java/" % module)
                    for group in groupid:
                        os.mkdir(group)
                        os.chdir(group)
        print("Folder structure generated successfully!")
    except Exception:
        print("Failed to create folder structure for each module!")
        print(traceback.format_exc())
    
    try:
        print("Generating parent pom file...")
        os.chdir(outputpath)
        os.system("freemarker-cli -t %s %s -o %s" % (str(templatepath.as_posix()), str(configpath.as_posix()), str(outputpath.as_posix()+"\pom.xml") ))
        print("Parent pom.xml is generated successfully!")
    except Exception:
        print("Failed to generate parent pom.xml!")
        print(traceback.format_exc())
        

def read_config(configpath):
    try:
        with open(configpath, 'r') as conf:
            data = yaml.safe_load(conf)
    except Exception:
        print("Failed to load yaml file! Please check the file again!")
        print(traceback.format_exc())

    return data


def parse_args():

    parser = argparse.ArgumentParser()
    parser.add_argument("-t", "--Template", help = "Determine template location", required=False)
    parser.add_argument("-c", "--Config", help = "Determine config file" , required=False)
    parser.add_argument("-o", "--Output", help = "Determine output directory", required=False)

    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    configpath = Path(args.Config)

    templatepath = Path(args.Template)

    outputpath = Path(args.Output)
    
    data = read_config(configpath)
    
    create_skeleton(configpath, templatepath, outputpath,data)

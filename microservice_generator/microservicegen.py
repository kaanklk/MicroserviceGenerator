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
import yaml
from pathlib import Path
import create_module as cm  

# Reading config.yaml file from configpath
def rconf(configpath):
    try:
        with open(configpath.joinpath("config.yaml"), 'r') as conf:
            root = yaml.safe_load(conf)
        return root
            
    except Exception as e:
        print("Failed to load yaml file! Please check the file again!")
        print(e)

def pargs():

    parser = argparse.ArgumentParser()
    parser.add_argument("-t", "--Template", help = "Determine template directory", required=True)
    parser.add_argument("-c", "--Config", help = "Determine config directory" , required=True)
    parser.add_argument("-o", "--Output", help = "Determine output directory", required=True)

    return parser.parse_args()


if __name__ == "__main__":
    args = pargs()
    configpath = Path(args.Config)
    templatepath = Path(args.Template)
    outputpath = Path(args.Output)

    root = rconf(configpath)
    cm.cmodule(templatepath=templatepath,outputpath=outputpath,root=root,configpath=configpath)


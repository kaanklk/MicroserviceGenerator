# :star: MicroserviceGenerator

Microservice Generator is a skeleton generator for applications designed by using Spring microservices architecture. It is designed as a solution for developers to help them write boilerplate code at the start of their project.  

Microservice Generator allows developers to create a configuration file and a list of jar files with the versions that developers will use in their applications. Microservice Generator will read that file and with the provided templates, It generates the application, tests, and configuration files to make it ready for the development phase. By generating CI/CD scripts on the way, the application on the start will be ready for the development phase very quickly.



# :rocket: Usage

Microservice Generator requires 3 mandatory arguments.

```
microservicegen.py [-h] -t TEMPLATE -c CONFIG -o OUTPUT

options:
  -h, --help            show this help message and exit
  -t TEMPLATE, --Template TEMPLATE
                        Determine template location
  -c CONFIG, --Config CONFIG
                        Determine config path
  -o OUTPUT, --Output OUTPUT
                        Determine output directory
```

Here is an example.

```
python .\microservicegen.py -t D:\template -c D:\config -o D:\target
```

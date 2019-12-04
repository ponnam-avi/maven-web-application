image: maven:latest

variables:
  MAVEN_CLI_OPTS: "-s .m2/settings.xml --batch-mode"
  MAVEN_OPTS: "-Dmaven.repo.local=.m2/repository"

cache:
  paths:
    - .m2/repository/
    - target/

build:
  stage: build
  script:
    - mvn $MAVEN_CLI_OPTS compile
sonarqube:
   stage: test
   script:
     - mvn clean package sonar:sonar -Dsonar.host.url=http://ec2-3-87-142-74.compute-1.amazonaws.com -Dsonar.login=4b10472faeabd02e136783eba7a052c02e0ff79a -Dsonar.login=admin -Dsonar.password=admin

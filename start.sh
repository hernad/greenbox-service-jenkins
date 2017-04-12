#!/bin/bash

# https://hub.docker.com/_/jenkins/

#DOCKER_JENKINS_VER="2.32.3-alpine"
DOCKER_JENKINS_VER="2.46.1-alpine"
CONTAINER_NAME=jenkins-1

docker pull jenkins:$DOCKER_JENKINS_VER

if [ ! -d jenkins_home ] 
then
  rclone copy -v gdrive_bout:/jenkins_home.tar.gz .
  tar xvf jenkins_home.tar.gz
fi

#docker exec -ti jenkins-1 cat /var/jenkins_home/secrets/initialAdminPassword

# get configuration
# docker cp jenkins-1:/var/jenkins_home .


#if you want to attach build slave servers: make sure you map the port: -p 50000:50000 - which will be used when you connect a slave agent.

docker rm -f $CONTAINER_NAME
docker run -d \
	 --name $CONTAINER_NAME \
	 -p 8080:8080 -p 50000:50000 \
	 -v $(pwd)/jenkins_home:/var/jenkins_home \
	 --env JAVA_OPTS=-Dhudson.footerURL=http://jenkins.bring.out.ba \
	 jenkins:$DOCKER_JENKINS_VER




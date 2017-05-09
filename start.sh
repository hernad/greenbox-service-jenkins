#!/bin/bash

# https://hub.docker.com/_/jenkins/

DOCKER_JENKINS_VER="2.46.2-alpine"
CONTAINER_NAME=jenkins-1

RCLONE_STORAGE_LOCATION=gdrive_bout:/jenkins_home
docker pull jenkins:$DOCKER_JENKINS_VER

if [ ! -d jenkins_home ] 
then
  echo "rclone get from gdrive_bout"
  rclone copy -v $RCLONE_STORAGE_LOCATION/jenkins_home.tar.xz .
  if [ $? != 0 ] ; then
      echo "rclone ERROR"
      exit 1
  fi
  tar xvf jenkins_home.tar.xz
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




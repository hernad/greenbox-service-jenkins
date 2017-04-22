#!/bin/bash

if ! rclone listremotes  | grep -q gdrive_bout
then
  echo "rclone mora biti konfigurisan - podesen remote gdrive_bout"
  exit 1
fi



if [ ! -d jenkins_home ]
then
	echo "We are not on right location: $(pwd) ?!"
	exit 1
fi

echo "stop jenkins-1"
docker stop jenkins-1
tar cvfJ jenkins_home.tar.xz jenkins_home
echo "start jenkins-1"
docker start jenkins-1

rclone copy -v jenkins_home.tar.xz gdrive_bout:/jenkins_home.tar.xz

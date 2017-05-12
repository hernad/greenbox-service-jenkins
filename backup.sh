#!/bin/bash

RCLONE_REMOTE=gdrive_out
RCLONE_STORAGE_LOCATION=$RCLONE_REMOTE:/jenkins_home

if ! rclone listremotes  | grep -q $RCLONE_REMOTE
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

rclone delete -v $RCLONE_STORAGE_LOCATION/1/jenkins_home.tar.xz
rclone copy -v $RCLONE_STORAGE_LOCATION/jenkins_home.tar.xz $RCLONE_STORAGE_LOCATION/1
rclone copy -v jenkins_home.tar.xz $RCLONE_STORAGE_LOCATION

rclone lsl  $RCLONE_STORAGE_LOCATION


#!/bin/bash


# Vars
# Name of the local ct
APP_IMG_NAME_LOCAL=green
# Official name of image, like on hub
APP_IMG_NAME=redbuild
# Version numnber as tag
VERSION_TAG=latest
# Gettingthe build version from the env build label of the dockerfile
BUILD_VERSION=`docker inspect -f '{{.Config.Labels.build_version}}' $APP_IMG_NAME `
#NEW_BUILD_VERSION=`wget -O- -q https://raw.githubusercontent.com/tiramisusolutions/dockerfiles/master/mr.caddy/VERSION`
CURRENT_CONTAINERS=`docker ps | grep $APP_IMG_NAME | awk '{print $1}'`
# Pre-defined port for green ct
GREEN_PORT=8080
# Pre-defined port for blue ct
BLUE_PORT=8081
# Check the port on which we are currently running on, this also tells if we are on blue or green
CURRENT_PORT=`docker inspect --format='{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}' $APP_IMG_NAME_LOCAL`
CURRENT_PORT=`docker inspect --format='{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}' $CURRENT_CONTAINERS`
# Functions

# Check if we have already the image and if the image is running
# Do we have the image ?
if [ ! -z $(docker images -q ${APP_IMG_NAME}:${VERSION_TAG}) ]; then
#if [ ! -z $(docker images -q myapp:2.0) ]; then
	: # Do nothing
else
	echo "Pulling the Image"
fi

# Is the Image running ?
if [ ! -z $CURRENT_CONTAINERS ]; then
	# Check the port
	#echo "Image is already running:"
	#echo "[HostPort]"
	#echo "$CURRENT_PORT"
	if [[ "$CURRENT_PORT" -eq "$GREEN_PORT" ]]; then
		echo "We are running on green build:[HostPort]:${GREEN_PORT} on version ${BUILD_VERSION} "
	elif [[ "$CURRENT_PORT" -eq "$BLUE_PORT" ]]; then
		echo "We are running on blue build:[HostPort]:${BLUE_PORT} on version ${BUILD_VERSION}"
	else
		echo "can't find the right port"
	fi
		
else
	echo "We have the image but it is not running"
fi

# Check the port we can use for the new image
#if [[ "$CURRENT_PORT" -eq "$GREEN_PORT" ]]; then
#	echo "We are running on green build"
#else
#	echo "We are running on blue build"
#fi

#echo "[Running containers]"
#echo "$CURRENT_CONTAINERS"

#D=`docker ps -l -q`
#NEW_ADDR=`docker port $NEW_ID 2015`
#NEW_PORT=${NEW_ADDR#0.0.0.0:}
#NEW_IP=`docker inspect --format="{{ .NetworkSettings.IPAddress }}" $NEW_ID`
#echo "[New container info]"
#echo "CONTAINER ID: ${NEW_ID}"
#echo "IP: ${NEW_IP}"
#echo "POERT: ${NEW_PORT}"



#echo "[Shutting down old containers]"
#if [ -n "$CURRENT_CONTAINERS" ]; then
#   docker kill $CURRENT_CONTAINERS
#fi


#echo "[Done]"
exit 0

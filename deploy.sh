#!/bin/bash
# Dependencies:
# - bash
# - wget

PROGNAME=$(basename $0)
# Colors
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
bold=`tput bold`
rev=`tput smso`
NORM=`tput sgr0`
BOLD=`tput bold`
REV=`tput smso`

# Reset all variables that might be set
file=
verbose=0

# Some Vars
# Official name of image, like on Docker Registry
APP_IMG_NAME=redbuild
# Pre-defined port for green ct
GREEN_PORT=8080
# Pre-defined port for blue ct
BLUE_PORT=8081
BUILD_VERSION=`docker inspect -f '{{.Config.Labels.build_version}}' $APP_IMG_NAME `
# Command to get remote version number, here from GitHub
#NEW_BUILD_VERSION=`wget -O- -q https://raw.githubusercontent.com/tiramisusolutions/dockerfiles/master/mr.caddy/VERSION`

# Functions
# Help
help_cmd() {
  echo -e \\n"Help documentation for ${BOLD}${SCRIPT}.${NORM}"\\n
  echo -e "${REV}Basic usage:${NORM} ${BOLD}$SCRIPT build_deb.bash${NORM}"\\n
  echo "Command line switches are optional. The following switches are recognized."
  echo "${REV}-v${NORM}  --Sets the version . Default is ${BOLD}0.1${NORM}."
  echo "${REV}-m${NORM}  --Sets mail. Default is ${BOLD}sven@so36.net${NORM}."
  echo "${REV}-u${NORM}  --Sets the user. Default is ${BOLD}zope${NORM}."
  echo "${REV}-g${NORM}  --Sets the group. Default is ${BOLD}zope${NORM}."
  echo "${REV}-p${NORM}  --Sets the prefix. Default is ${BOLD}/srv/zope${NORM}."
  echo "${REV}-n${NORM}  --Sets the name. Default is ${BOLD}vmd.demo.site${NORM}."
  echo "${REV}-t${NORM}  --Sets the target dir. Default is ${BOLD}vmd.demo${NORM}."
  echo -e "${REV}-h${NORM}  --Displays this help message. No further functions are performed."\\n
  echo -e "Example: ${BOLD} ./build_deb.bash -m sven@leftxs.org -n MYNAME -p /home/sven${NORM}"\\n
  exit 1
}

# Check if we have the image already locally
check_imgage_local(){
  #if [ ! -z $(docker images -q ${APP_IMG_NAME}:${VERSION_TAG}) ]; then
  if [ ! -z $(docker images --format "{{.Repository}}:{{.Tag}}") ]; then
  : # Do nothing we have the image already local
else
  echo "Pulling the Image: "$APP_IMG_NAME":"$NEW_VERSION""
fi
}

# Check local image
if docker images --format "{{.Repository}}:{{.Tag}}" | grep -q redbuild:latest; then echo "yes"
fi

# Check the ports, to find out if we are on blue or green
check_local_ports(){
  if [ ! -z $CURRENT_CONTAINERS ]; then
    if [[ "$CURRENT_PORT" -eq "$GREEN_PORT" ]]; then
      echo "We are running on green build:[HostPort]:${GREEN_PORT} on version ${BUILD_VERSION} "
    elif [[ "$CURRENT_PORT" -eq "$BLUE_PORT" ]]; then
      echo "We are running on blue build:[HostPort]:${BLUE_PORT} on version ${BUILD_VERSION}"
    else
      echo "We have the image but it is not running on Green:"${GREEN_PORT}" or on Blue:"${BLUE_PORT}""
    fi
    
  else
    echo "We have the image but it is not running"
  fi
}

### Start getopts code ###
while getopts :v:n:t:p:h FLAG; do
  case $FLAG in
    v)  #set option "version"
      NEW_VERSION=$OPTARG
      echo "NEW_VERSION = $NEW_VERSION"
      ;;
    n) #set option "name"
      APP_IMG_NAME=$OPTARG
      #echo "-n used: $OPTARG"
      echo "APP_IMG_NAME = $APP_IMG_NAME"
      ;;
    p) # set prefix
      PREFIX=$OPTARG
      echo "-p used: $OPTARG"
      echo "PREFIX = $PREFIX"
      ;;
    h)  #show help
      HELP
      ;;
    \?) #unrecognized option - show help
      echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
      HELP
      #If you just want to display a simple error message instead of the full
      #help, remove the 2 lines above and uncomment the 2 lines below.
      #echo -e "Use ${BOLD}$SCRIPT -h${NORM} to see the help documentation."\\n
      #exit 2
      ;;
  esac
done

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.

### End getopts code ###

#echo "deploy -n "$NAME" -v "$VERSION""
#echo "deploy "$APP_IMG_NAME":"$NEW_VERSION""
echo "Checking for image, please stand by"
check_imgage_local

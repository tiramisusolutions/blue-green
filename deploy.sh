#!/bin/bash

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


#Help function
function HELP()
{
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


### Start getopts code ###
while getopts :v:m:u:g:n:t:p:h FLAG; do
  case $FLAG in
    v)  #set option "version"
      VERSION=$OPTARG
      echo "VERSION = $VERSION"
      ;;
    m)  #set option "mail"
      MAILADRES=$OPTARG
      echo "-m used: $OPTARG"
      echo "MAILADRES = $MAILADRES"
      ;;
    u)  #set option "user"
      USER=$OPTARG
      echo "-u used: $OPTARG"
      echo "USER = $USER"
      ;;
    g)  #set option "group"
      GROUP=$OPTARG
      echo "-g used: $OPTARG"
      echo "GROUP = $GROUP"
      ;;
    n) #set option "name"
      NAME=$OPTARG
      #echo "-n used: $OPTARG"
      echo "NAME = $NAME"
      ;;
    t) #set option "target dir"
      TARGETDIR=$OPTARG
      echo "-d used: $OPTARG"
      echo "NAME = $TARGETDIR"
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
echo "deploy "$NAME":"$VERSION""

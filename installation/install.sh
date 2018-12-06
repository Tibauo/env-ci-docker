#!/bin/bash

PROGNAME=$0

# Setup script directory
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD/.."; fi

USER=Tibauo
PASSWORD=abcd1234
EMAIL=demo@monmail.fr
REPOSITORY=demo

usage(){
cat <<EOF
  -h : help
  -u : le user pour Gitlab, Jenkins & Nexus
  -p : le password pour Gitlab, Jenkins & Nexus
  -r : le nom du repository
  -e : votre proxy sous la fome "http://nom:password@adresse"
  Exemple: bash $0 -u MonUser -p MonPassword 

EOF
  exit 1
}

while getopts ":h:u:p:e:" option; do
  case "${option}" in
    h) 
      usage
    ;;
    r)
      REPOSITORY=${OPTARG}
    ;;
    u)
      USER=${OPTARG}
    ;;
    p)
      PASSWORD=${OPTARG}
    ;;
    e)
      proxy=${OPTARG}
      export http_proxy="$proxy"
      export https_proxy="$proxy"
    ;;

    *)
      usage
    ;;
    esac
done

##################################
#      Setup log directory       #
##################################

LOGPATH=$DIR/installation/log/
LOGFILE=$DIR/installation/log/installation.log

if [ -f $LOGFILE ]; then
  echo "file exist"
elif [ -d $LOGPATH ]; then
  echo "Directory exists $LOGPATH"
  echo "Creating File"
  touch $LOGFILE
  echo
else
  mkdir -p $LOGPATH
  touch $LOGFILE
fi

setup() {
 term=$(tty)
 if (( $? != 0 ))
 then
  exec 1<&-
  exec 2<&-
  exec 1<> $LOGFILE
  exec 2>&1
  echo "Script is not executed from a terminal"
 else
  exec 1<> $LOGFILE
  exec 2>&1
  tail --pid $$ -f $LOGFILE >> $term & echo "Script is executed from a terminal"
 fi
}

######################################
#             Fonctions              #
######################################

if [ -d $DIR/ci/ ]; then
  echo "Directory exists $DIR/ci"
else
  echo "Creating directory $DIR/ci"
  mkdir -p $DIR/ci/
fi


setup echo "Installation et configuration de l'environnement de CI"

source $DIR/installation/ressources/gitlab/Post_Configure.sh
source $DIR/installation/ressources/nexus/Post_Configure.sh
source $DIR/installation/ressources/jenkins/Post_Configure.sh
source $DIR/installation/ressources/compose/compose.sh


createJob
cd $DIR/installation/ressources/jenkins/docker
docker build --rm . -t jenkins-demo

cd $DIR/ci
prepareDockerCompose
docker-compose up -d
cd $DIR/installation

postConfigureGitlab
postConfigureNexus
postConfigureJenkins
cd $DIR/installation/ressources/projet
git config --global user.name "Tibauo"
git config --global user.email "demo@monmail.fr"
git init
git remote add origin http://$USER:$PASSWORD@localhost/Tibauo/demo.git
git add .
git commit -m "Initial commit"
git push -u origin master

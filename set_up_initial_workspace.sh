#!/bin/bash

services=(
turnstile
customerservice
entry_service
catalog_service
orders_service
competition_management
payment_service
communication_service
infra
communication_service_client
payment_service_client
orders_service_client
entry_service_client
competition_service_client
customer_service_client
catalog_service_client
scheduler
silverpop_mock
xsgate_mock
migration_service
bash_preferences
pools_errors
pools_error_definitions
pools_health_checks
playthepools
balance_checker
go-config-backup
deployment
authentication_service
scheduler
offer_service
offer_service_client
mobile_poc
functional_tests
config_loader
silverpop_mock_client
pools_person_validation
Confero
legacy_service
baseboxes
pools_person_validator
errbit
rails_time_travel
performance
monitoring_system
csipaf
uat_issue_debugging
pools_error_handler
jmeter_extension
clerity
deb-nginx
texticle
EngineBrake
tire
pools_logger
deb-passenger
)


#echo "Array size: ${#services[*]}"




#create directories if non-existent
function create_directories {
  for item in ${services[*]}
  do
      #printf "   %s\n" $item
      if [ -d "/home/ad/workspace/$item" ]
      then
        #Control will enter here if $DIRECTORY exists.
        echo "directory $item already exists!"
      else
        mkdir /home/ad/workspace/$item
        echo /home/ad/workspace/$item
      fi	
  done
}





#create git repositories for each
function git_setup_init {
#initialise git repository
git init /home/ad/workspace/$1

#set the .git/config file 
cat << UDK_TERMINATOR > /home/ad/workspace/$1/.git/config
[core]
	repositoryformatversion = 0
	filemode = true
	bare = false
	logallrefupdates = true
[remote "origin"]
	fetch = +refs/heads/*:refs/remotes/origin/*
	url = git@github.com:Sportech/$1.git
[branch "master"]
	remote = origin
	merge = refs/heads/master
UDK_TERMINATOR
#terminator, whole line is read and must only contain UDK_TERMINATOR, no spaces.

}





#pull all repositories from github
function git_setup_pull_from_github {

echo "####currently pulling services"

for i in ${!services[*]}
do
  cd /home/ad/workspace/${services[$i]}
  git pull &  #run pull in background
  pid[$i]=$!  #get process id in array, parallel to service
done

for i in ${!services[*]}
do
  wait ${pid[i]}  #wait for pull to finish  
done

echo "####successfully pulled services"

}





#main function
function main {

#create the directories for the services if non-existent
create_directories

#iterate through and initialise git with config
for i in ${!services[*]}
do
  git_setup_init ${services[$i]}
done

#iterate through and pull from github
git_setup_pull_from_github

echo "##########Successfully set up workspace services##########"
}





if [ -d "/home/ad/workspace" ]
then
  echo "ABORTED! home/ad/workspace already exists!"  
else
  mkdir /home/ad/workspace
  main 
  cd /home/ad/workspace
fi

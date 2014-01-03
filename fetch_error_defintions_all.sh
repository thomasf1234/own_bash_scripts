#!/bin/bash

#must do all in the background and write log to screen after each fetch
function fetch_all {

  #fetch_error_definitions_for_opt

  cd $HOME/workspace

  directories=($(ls -lt | awk '{print $9}'))

	for i in ${!directories[@]}
	do
		cd $HOME/workspace/${directories[$i]}

		if [ -f "./script/ci_fetch_error_definitions" ]
      then
        echo "##########fetching_error_definitions for ${directories[$i]}##########"
        ./script/ci_fetch_error_definitions
      fi
	done
}

#must finish
function fetch_error_definitions_for_opt {
  :
}

fetch_all "$@"

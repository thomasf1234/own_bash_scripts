#!/bin/bash

#must do all in the background and write log to screen after each fetch
function check_git_status_all {

  cd $HOME/workspace

  directories=($(ls -lt | awk '{print $9}'))


	for i in ${!directories[@]}
	do
		cd $HOME/workspace/${directories[$i]}

		if [ -d ".git" ]
      then
        echo "##########git status for ${directories[$i]}##########"
        git status
        echo "" && echo "" && echo ""
      fi
	done
}

check_git_status_all "$@"

#!/bin/bash

#write scripts to:
#git_log_search
#delete temp files *~

#git log -p

#compgen -c | sort -t '\0'

function search {
  
  cd $HOME/workspace
  
  directories=($(ls -lt | awk '{print $9}'))
  
  file_name=$(eval date +%Y_%m_%d"__"%H:%M)
  
	for i in ${!directories[@]}
	do
		cd $HOME/workspace/${directories[$i]}
		

		if [ -d ".git/logs/" ]
      then
        #Control will enter here if $DIRECTORY exists
        echo "##########${directories[$i]}##########" >> $HOME/git_logs/$file_name.log
        git log --grep "$1" >> $HOME/git_logs/$file_name.log
        echo "" && echo "" && echo "" >> $HOME/git_logs/$file_name.log
      fi
	done
}

search "$@"


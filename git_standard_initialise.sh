#!/bin/bash

#create standard git repository for current directory
function git_setup_init { 

#get name of current directory
curr_dir_path=$(pwd)
curr_dir_name=$(basename $curr_dir_path)

#if git repository already exists
if [ -d "$curr_dir_path/.git" ]
 then
   echo "git_setup_init aborted, git repository already exists."
   exit
fi

#initialise git repository
git init

#set the .git/config file 
cat << UDK_TERMINATOR > $curr_dir_path/.git/config
[core]
	repositoryformatversion = 0
	filemode = true
	bare = false
	logallrefupdates = true
[remote "origin"]
	fetch = +refs/heads/*:refs/remotes/origin/*
	url = git@github.com:thomasf1234/$curr_dir_name.git
[branch "master"]
	remote = origin
	merge = refs/heads/master
UDK_TERMINATOR
#terminator, whole line is read and must only contain UDK_TERMINATOR, no spaces.

echo "must create Github repository: https://github.com/thomasf1234/$curr_dir_name" 

}

git_setup_init 

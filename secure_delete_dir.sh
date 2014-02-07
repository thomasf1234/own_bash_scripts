#!/bin/bash

function if_directory {
  if [ -d "$1" ];
  then
    find $1 -type f -exec secure_delete.sh {} \; 
  elif [ -f "$1" ];
  then
    secure_delete.sh $1
  else
    echo "$1 is neither a directory nor file"
    return "false"
  fi
}

function remove_directory_if_empty {
  if [ -z "$(find $1 -type f)" ]; then
    rm -rf $1
  else
    echo "Danger! There are still files, not all has been securely wiped!"
fi
}

if_directory $1
remove_directory_if_empty

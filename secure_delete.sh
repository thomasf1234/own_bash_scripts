#!/bin/bash

#secure delete file and temporary if they exist
#must pass in the file path of the non-temporary file i.e.
#bash secure_delete.sh /home/username/dir/file

function secure_delete_file {

  if [ ! -f "$1" ];
  then
    echo "**********$1 not found**********"
    echo "nothing has been done..."
    return
  fi

  FILE_PATH=$1 #"/home/ad/insert_command.psql"
  DIR=${FILE_PATH%/*}
  FILE_NAME=${FILE_PATH##*/} #$(basename $FILE_PATH)
  #echo $FILE_PATH
  #echo $DIR
  #echo $FILE_NAME
  BYTES="$(cd $DIR && (ls -lt | grep $FILE_NAME$ | awk '{print $5}'))"
  #echo $BYTES
  COMMAND="dd if=/dev/urandom of=$FILE_PATH bs=$BYTES count=1 conv=notrunc"
  echo "**********WIPING '$FILE_PATH' **********"
  for ((n=1;n<8;n++))
  do 
    echo "beginning to execute secure wipe $n ..."
    $COMMAND 
    #echo "$COMMAND"
    EXIT_STATUS="$?"
    echo "finished executing secure wipe $n , exit status: $EXIT_STATUS."
    echo ""
  done
  
  delete_files $FILE_PATH
}

function delete_temp_file_also {
  secure_delete_file "$1~"
}

function delete_files {
  rm $1
  EXIT_STATUS=$?
  if [ "$EXIT_STATUS" == "0" ];
  then
    echo "successfully deleted $1"
  else
    echo "ERROR when attempting to delete $1, \n   exit status: $EXIT_STATUS"
  fi
}

function check_if_still_there {
  if [ -f "$1" ] || [ -f "$1~" ]
  then
    echo "*******DANGER!! FILE IS STILL THERE, YOU MUST INVESTIGATE, MAY NOT BE WIPED!!!!*******"
    #securely_delete_file_with_temporary
  else
    echo "**********files have been securely deleted.**************"
  fi
}

function check_if_there {
  if [ -f "$1" ];
  then
    return "true"
  else
    echo "$1 not found, exiting..."
    return "false"
  fi
}


function securely_delete_file_with_temporary {
secure_delete_file $1
delete_temp_file_also $1
check_if_still_there $1
}

#need to fix
function check_input {
  if [ "$#" -eq 0 ];
  then
    echo "no arguments provided, this method accepts 1 argument; a file_path i.e '/home/username/dir/file'"
  elif [ "$#" -gt 1 ];
  then
    echo "Too many arguments, this method accepts 1 argument; a file_path i.e '/home/username/dir/file'"
  else
    securely_delete_file_with_temporary $1 
  fi
}

check_input $1


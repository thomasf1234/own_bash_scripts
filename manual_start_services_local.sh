#!/bin/bash

services=(
"turnstile | ts | 3000"
"customerservice | cs | 3001"
"entry_service | es | 3007"
"catalog_service | cat | 3003"
"orders_service | os | 3004"
"competition_management | comp | 3006"
"payment_service | ps | 3005"
"communication_service | comms | 3008"
"offer_service | off | 3009"
"silverpop_mock | spm | 9001"
"xsgate_mock | xsm | 9002"
)

#addition 4 7 => sum=11
function addition { #(num1, num2)
  sum=$(($1 + $2))
}

#$(element "${array[i]}" j) for the (i,j) element in an array described by:
#array=(
#   "a0 | a1 | a2"
#   "b0 | b1"
#   "c0 | c1 | c2 | c3"
#   )
#i.e.  array[2,3] => element "${array[2]}" 3 => prints "c3"
#i.e.  element "${services[0]}" 2 => prints "3000"
function element { #(i, j)
  INPUT="$1"
  addition $2 1
  SUBSTRING=`echo $INPUT| cut -d'|' -f $sum`
  echo $SUBSTRING
}


function open_tabs {
  for i in ${!services[@]}
  do
    foo+=(--tab -e "bash -c \"exec bash --init-file $HOME/own_bash_scripts/tmp_bashrc/.bashrc_replacement_$(element "${services[$i]}" 0).sh\"")
    tmp_bashrc
    #chmod 777 $HOME/workspace/tmp_bashrc/.bashrc_replacement_$(element "${services[$i]}" 0).sh
  done

  gnome-terminal "${foo[@]}" --geometry=173x40+1985+80
  #gnome-terminal --geometry=173x40+1985+80

}


#creates temporary replacement .bashrc files for each tab
function tmp_bashrc {

cat << UDK_TERMINATOR > $HOME/own_bash_scripts/tmp_bashrc/.bashrc_replacement_$(element "${services[$i]}" 0).sh

common_commands=(
"bundle install"
"bundle exec rake db:drop RAILS_ENV=development"
"bundle exec rake db:create RAILS_ENV=development"
"bundle exec rake db:migrate RAILS_ENV=development"
"bundle exec rake db:seed RAILS_ENV=development"
"bundle exec rake db:drop RAILS_ENV=test"
"bundle exec rake db:create RAILS_ENV=test"
"bundle exec rake db:migrate RAILS_ENV=test"
)

##################################################################### not yet used
#workers must wait for service
workers_commands=(
"cd orders_service && bundle exec rake resque:work QUEUE=orders_service &"
"cd payment_service && bundle exec rake resque:work QUEUE=payment_service &"
"cd communication_service && bundle exec rake resque:work QUEUE=communication_service &"
"cd competition_management && bundle exec rake resque:work QUEUE=competition_management &"
)

function clear_redis {
  redis-cli flushdb
}

function start_resque {
  resque-web
}

#function start_workers {

#}
#####################################################################



#create the commands to run in each tab
function create_commands {
  cmd=""
  for item in "\${common_commands[@]}"
  do
          cmd+="\$item; "
  done

  if [ "$(element "${services[$i]}" 0)" == "customerservice" ]
  then
    cmd+="bundle exec rails s -p 3001 -e testintegration; "
  elif [ "$(element "${services[$i]}" 0)" == "catalog_service" ]
  then
    #wait_for_other_service "competition_management"
    wait_for_other_service "$(element "${services[5]}" 2)"
    cmd+="bundle exec rails s -p $(element "${services[$i]}" 2); "
  elif [ "$(element "${services[$i]}" 0)" == "competition_management" ]
  then
    cmd="bundle install;"
    cmd+="bundle exec rake db:reset RAILS_ENV=development;"
    cmd+="bundle exec rake db:reset RAILS_ENV=test;"
    cmd+="bundle exec rails s -p $(element "${services[$i]}" 2); "
  else
   cmd+="bundle exec rails s -p $(element "${services[$i]}" 2); "
  fi
 }

 function wait_for_other_service { #need to include a time-out
  until [[ -n \$(lsof -i :\$1) ]] #check if this is actually the file to check!
  do
    echo "waiting for service listening on port \$1"
    sleep 5
    #: #noop
  done
 }

. /etc/bash.bashrc
. $HOME/.bashrc
. $HOME/.bash_profile

PS1="\${debian_chroot:+(\$debian_chroot)}\u@\h \w\a$ "
echo -en "\033]0;$(element "${services[$i]}" 1)\a"

cd $HOME/workspace/$(element "${services[$i]}" 0)
create_commands

bash -c "\$cmd"


echo "hello, I am $(element "${services[$i]}" 0)"


UDK_TERMINATOR
#terminator, whole line is read and must only contain UDK_TERMINATOR, no spaces.
}

mkdir $HOME/own_bash_scripts/tmp_bashrc
open_tabs


exit 0

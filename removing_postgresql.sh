#!/bin/bash

remove_list=($(dpkg -l | grep postgres | awk '{print $2}'))


for i in ${!remove_list[@]}
do
  sudo apt-get --purge remove ${remove_list[$i]}
  #echo "sudo apt-get --purge remove ${remove_list[$i]}"
done




#sudo apt-get --purge remove postgresql
#dpkg -l | grep postgres  #lists dependencies that also need to be removed

#installs: rvm, rubies, bundler_global, gmate

#!/bin/bash


rubies_list=(
1.8.7-p370
1.9.2-p320
1.9.3-p0
1.9.3-p194
1.9.3-p286
)

function install_rubies {
  for item in ${rubies_list[*]}
  do
    rvm install $item
  done
}

function install_gmate {
  sudo apt-add-repository ppa:ubuntu-on-rails/ppa
  sudo apt-get install gedit-gmate #probably need to update ubuntu
  sudo apt-get install gedit-plugins
}


function main {
  echo "starting installation, please wait..."
  \curl -L https://get.rvm.io | bash
  source /home/ad/.rvm/scripts/rvm
  install_rubies
  rvm @global do gem install bundler
  rvm --default use 1.9.2-p320
  install_gmate
  echo "finished installing."
}

main

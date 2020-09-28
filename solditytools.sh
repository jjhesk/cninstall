#!/usr/bin/env bash

nvm use 11
brew install rsync
brew install jq
brew install moreutils
brew install cmake

cnpm i -g @0x/abi-gen


linuxtools(){
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  #https://snapcraft.io/install/solc/centos
  sudo yum install rsync
}



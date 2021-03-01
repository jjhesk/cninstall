#!/usr/bin/env bash

nvm use 11
brew install rsync
brew install jq
brew install moreutils
brew install cmake


linuxtools(){
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  #https://snapcraft.io/install/solc/centos
  sudo yum install rsync

  cnpm i -g @0x/abi-gen
}
# detail installation works
# https://github.com/crytic/solc-select/releases/tag/0.2.0
pypinstall(){
	pip3 install solc-select
	solc-select install
	solc-select install 0.8.0
	solc-select install 0.8.1
	solc-select install 0.5.0
	solc-select install 0.5.16
	solc-select install 0.5.10
	solc-select install 0.5.0
	solc-select install 0.5.15
	solc-select install 0.6.0
	solc-select install 0.6.1
	solc-select versions

	SOLC_VERSION=0.5.16 solc
}


pypinstall
#!/usr/bin/env bash

nvm use 11
brew install rsync
brew install jq
brew install moreutils
brew install cmake

linuxtools() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  #https://snapcraft.io/install/solc/centos
  sudo yum install rsync
  cnpm i -g @0x/abi-gen
}

# detail installation works
# https://github.com/crytic/solc-select/releases/tag/0.2.0
pypinstall() {
  pip3 install solc-select
  solc-select install

  solc-select install 0.5.14
  solc-select install 0.5.17
  solc-select install 0.6.2
  solc-select install 0.6.3
  solc-select install 0.6.4
  solc-select install 0.6.5
  solc-select install 0.6.6
  solc-select install 0.6.7
  solc-select install 0.6.8
  solc-select install 0.6.9
  solc-select install 0.6.10
  solc-select install 0.6.11
  solc-select install 0.6.12
  solc-select install 0.7.0
  solc-select install 0.7.1
  solc-select install 0.7.2
  solc-select install 0.7.3
  solc-select install 0.7.4
  solc-select install 0.7.5
  solc-select install 0.7.6
  solc-select install 0.8.2
  solc-select install 0.8.3
  solc-select install 0.8.4
  solc-select install 0.8.5
  solc-select install 0.8.6
  solc-select install 0.8.7
  solc-select install 0.8.12

  solc-select versions

  SOLC_VERSION=0.5.16 solc
}

pypinstall

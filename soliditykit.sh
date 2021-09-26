#!/bin/sh
clear
yum install rsync

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo -e "${new// /.}"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "${new// /.}"
elif [[ "$OSTYPE" == "cygwin" ]]; then
    echo "not correct system - cygwin detected"
    exit
fi

pip3 install solc-select
pip3 install slither-analyzer

echo '...done'
echo 'Installation has completed.'
echo 'Config execution with robot -s node.fmz.com/xxxxxx -p yourFMZpassword xxxxxx'
echo 'you can run the service by executing this command [nohup robot -s node.fmz.com/xxxxxx -p yourFMZpassword &]'
echo 'please refer to https://www.fmz.com/digest-topic/5711 for the complete user guide'

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

SOLC_VERSION=0.5.7 solc

# [![](https://data.jsdelivr.com/v1/package/gh/jjhesk/cninstall/badge?style=rounded)](https://www.jsdelivr.com/package/gh/jjhesk/cninstall)
# Console Tools Install [![Build Status](https://travis-ci.org/canha/cninstall.svg?branch=master)](https://travis-ci.org/canha/cninstall)

Latest Version: v1.4.91

## The collection of system tools for your linux build

## :hammer: Requirements
* `wget` or `curl`
* Bash shell

## :fast_forward: Install

Download and run with `wget` or `curl`. Here's the short version using the official git.io shortening:


### Check for any of the working installation one line script

if you want to install brewinstall.sh

`wget -q -O - https://cdn.jsdelivr.net/gh/jjhesk/cninstall@rc1.5.103/brewinstall.sh | bash`


if you want to install bt_patch.sh

`wget -q -O - https://cdn.jsdelivr.net/gh/jjhesk/cninstall@rc1.5.103/bt_patch.sh | bash`


if you want to install ccinstall.sh

`wget -q -O - https://cdn.jsdelivr.net/gh/jjhesk/cninstall@rc1.5.103/ccinstall.sh | bash`


if you want to install chiaminersetup.sh

`wget -q -O - https://cdn.jsdelivr.net/gh/jjhesk/cninstall@rc1.5.103/chiaminersetup.sh | bash`


if you want to install fmzrobot.sh

`wget -q -O - https://cdn.jsdelivr.net/gh/jjhesk/cninstall@rc1.5.103/fmzrobot.sh | bash`


if you want to install goinstall.sh

`wget -q -O - https://cdn.jsdelivr.net/gh/jjhesk/cninstall@rc1.5.103/goinstall.sh | bash`


if you want to install ngrokinstall.sh

`wget -q -O - https://cdn.jsdelivr.net/gh/jjhesk/cninstall@rc1.5.103/ngrokinstall.sh | bash`


if you want to install nvminstall.sh

`wget -q -O - https://cdn.jsdelivr.net/gh/jjhesk/cninstall@rc1.5.103/nvminstall.sh | bash`


if you want to install pip_mirror_setup.sh

`wget -q -O - https://cdn.jsdelivr.net/gh/jjhesk/cninstall@rc1.5.103/pip_mirror_setup.sh | bash`


if you want to install solditytools.sh

`wget -q -O - https://cdn.jsdelivr.net/gh/jjhesk/cninstall@rc1.5.103/solditytools.sh | bash`

## Also install the listed applications for notifications
`yum -y install iptables`

`yum -y install sendmail`

`yum install -y mailx`

### Tested working on:

* :white_check_mark: Ubuntu 16.04 to 18.04
* :white_check_mark: macOS Sierra (10.12) to Catalina (10.15)

### Other related installations:

`bash <(curl -Ss https://my-netdata.io/kickstart.sh)`

### BT Installation

#### CENTOS

`yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh`

#### UBUNTU

`wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && sudo bash install.sh`



### Auto disk

`yum install wget -y && wget -O auto_disk.sh http://download.bt.cn/tools/auto_disk.sh && bash auto_disk.sh`


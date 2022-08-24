#!/usr/bin/env bash

#china https://mirrors.aliyun.com/pypi/simple/

sudo yum -y install wget
cd ~
wget https://www.python.org/ftp/python/3.10.4/Python-3.10.4.tgz
tar xvf Python-3.10.4.tgz
cd Python-3.10*/
./configure --enable-optimizations
sudo make altinstall
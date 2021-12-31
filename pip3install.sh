#!/usr/bin/env bash

#china https://mirrors.aliyun.com/pypi/simple/

mkdir ~/.pip
cat <<EOF > ~/.pip/pip.conf
 [global]
 trusted-host = mirrors.aliyun.com
 index-url = http://mirrors.aliyun.com/pypi/simple
EOF

#pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple/

pip3 config set global.index-url https://pypi.python.org/simple
yum install -y python38 python36 python39 python40

mv /usr/bin/python3 /usr/bin/python3.bak
ln -s /usr/bin/python3.8 /usr/bin/python3

yum install -y wkhtmltox-0.12.6-1.centos8.x86_64.rpm

sudo yum install python3-devel
sudo pip3 install Cython
python3 -m pip install --upgrade pip

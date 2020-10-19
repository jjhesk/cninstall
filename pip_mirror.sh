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
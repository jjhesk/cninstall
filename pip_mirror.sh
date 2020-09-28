#!/usr/bin/env bash
mkdir ~/.pip
cat <<EOF > ~/.pip/pip.conf
 [global]
 trusted-host =  mirrors.aliyun.com
 index-url = http://mirrors.aliyun.com/pypi/simple
EOF

pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple/
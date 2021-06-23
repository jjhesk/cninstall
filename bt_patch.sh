#!/bin/sh
clear
echo; echo 'Installing BT patch 1.01'; echo

RELEASE_TAG=0.990
FILE1=https://cdn.jsdelivr.net/gh/ONode/BTB@$RELEASE_TAG/BTPanel/static/js/index.js
FILE2=https://cdn.jsdelivr.net/gh/ONode/BTB@$RELEASE_TAG/BTPanel/__init__.py
BASE_PANEL=/www/server/panel

echo 'search for version'

if [ ! -d $BASE_PANEL ];then
	echo "BT is not install, exit."
	exit
fi



wget -q $FILE1 -O $BASE_PANEL/BTPanel/static/js/index.js
wget -q $FILE2 -O $BASE_PANEL/BTPanel/__init__.py

cd $BASE_PANEL

sh init.sh reload

echo '...done with the new patch'
echo 'Installation has completed.'
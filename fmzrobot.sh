#!/bin/sh
clear
echo; echo 'Installing FMZ robot engine 1.1'; echo

cd home
wget https://www.fmz.com/dist/robot_linux_amd64.tar.gz
tar -xzvf robot_linux_amd64.tar.gz
echo '...grant execution permission'
chmod +x robot
echo '...move path'
mv robot /bin/robot
echo '...done'
echo 'Installation has completed.'
echo 'Config execution with robot -s node.fmz.com/xxxxxx -p yourFMZpassword xxxxxx'
echo 'you can run the service by executing this command [nohup robot -s node.fmz.com/xxxxxx -p yourFMZpassword &]'
echo 'please refer to https://www.fmz.com/digest-topic/5711 for the complete user guide'
#!/bin/sh
if [ -d '/usr/local/ddos' ]; then
    echo; echo; echo "Please un-install the previous version first"
    exit 0
else
    mkdir -p /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Defender 1.1'; echo
GH_TAG="genesis"


filegh(){
    local f=$1
    local tmp="https://raw.githubusercontent.com/NLPPort/DDosChecker/master/ddos/"
    echo "${tmp}${f}"
}

filecdn(){
    local f=$1
    local tmp="https://cdn.jsdelivr.net/gh/NLPPort/DDosChecker@${GH_TAG}/ddos/"
    echo "${tmp}${f}"
}

wget -q -O /usr/local/ddos/ddos.sh $(filecdn "ddos.sh")
echo -n '.'
wget -q -O /usr/local/ddos/ddos.conf $(filecdn "ddos.conf")
echo -n '.'
wget -q -O /usr/local/ddos/ban.ip.list $(filecdn "ban.ip.list")
echo -n '.'
wget -q -O /usr/local/ddos/list.sh $(filecdn "list.sh")
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list $(filecdn "ignore.ip.list")
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE $(filecdn "LICENSE")
echo -n '.'

chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'

#echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
#/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1

echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'
echo
cat /usr/local/ddos/LICENSE | less
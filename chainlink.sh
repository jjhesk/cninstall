#!/bin/sh
clear
yum install rsync
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user
python3 -m pip install --user ansible
python3 -m pip install --user paramiko

sudo python3 get-pip.py
sudo python3 -m pip install ansible
sudo yum install epel-release
sudo yum install ansible
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
nvm install 12
nvm install 13
nvm install 14
nvm install 15
nvm install 16
nvm use 12

ansible-galaxy collection install community.general  
ansible-galaxy collection install ansible.posix  



cd ~
mkdir -p /home/www
cd /home/www

git clone https://github.com/WilsonBillkia/bane.git && cd bane

git clone https://github.com/smartcontractkit/chainlink.git && cd chainlink

git checkout tags/v0.10.14

sudo yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

sudo yum -y update
sudo yum repolist
sudo yum search postgresql13
sudo yum -y install postgresql13 postgresql13-server
sudo /usr/pgsql-13/bin/postgresql-13-setup initdb
sudo systemctl start postgresql-13
sudo systemctl enable postgresql-13


#yarn install
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
sudo rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg
sudo yum install yarn






# DATABASE_URL=postgresql://$USERNAME:$PASSWORD@$SERVER:$PORT/$DATABASE
USERNAME
PASSWORD
PORT
DATABASE
echo "DATABASE_URL=postgresql://$USERNAME:$PASSWORD@$SERVER:$PORT/$DATABASE" >> ~/.chainlink-rinkeby/.env




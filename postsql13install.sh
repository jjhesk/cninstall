#!/usr/bin/env bash


OS="$(uname -s)"
ARCH="$(uname -m)"

case $OS in
    "Linux")
        case $ARCH in
        "x86_64")
            ARCH=amd64
            ;;
        "aarch64")
            ARCH=arm64
            ;;
        "armv6")
            ARCH=armv6l
            ;;
        "armv8")
            ARCH=arm64
            ;;
        .*386.*)
            ARCH=386
            ;;
        esac
        PLATFORM="linux-$ARCH"
    ;;
esac

if [ -z "$PLATFORM" ]; then
    echo "Your operating system is not supported by the script."
    exit 1
fi



# Install the repository RPM:
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# Disable the built-in PostgreSQL module:
sudo dnf -qy module disable postgresql
# Install PostgreSQL:
sudo dnf install -y postgresql13-server
yum install -y postgresql13-server postgresql13-contrib postgresql13-devel
#apt install -y postgresql14-server postgresql14-contrib postgresql14-devel
# Optionally initialize the database and enable automatic start:
sudo /usr/pgsql-13/bin/postgresql-13-setup initdb
sudo systemctl enable postgresql-13
sudo systemctl start postgresql-13
sudo systemctl status postgresql-13

sudo -u postgres psql



#ALTER USER postgres WITH PASSWORD 'ffex123rr';
ALTER USER graphicaltester1 WITH PASSWORD 'ffex123rr';

# TYPE  DATABASE        USER            ADDRESS                 METHOD
# "local" is for Unix domain socket connections only
#local   all             all                                     trust
# IPv4 local connections:
#host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
#host    all             all             ::1/128                 trust
# Allow replication connections from localhost, by a user with the
# replication privilege.
#local   replication     all                                     trust
#host    replication     all             127.0.0.1/32            trust
#host    replication     all             ::1/128                 trust
#host    graphnod  graphnodeadmin    127.0.0.1/32    md5

#database: graphicalnode99
#user:graphuser

cd /usr/pgsql-13/bin
sudo -u postgres psql -c "CREATE DATABASE graphicalnode99;"
sudo -u postgres psql -c "CREATE ROLE admin WITH SUPERUSER CREATEDB CREATEROLE LOGIN PASSWORD 'ffex123rr';"

#\c graphicalnode99

#CREATE ROLE admin WITH CREATEDB CREATEROLE LOGIN PASSWORD 'ffex123rr' ;
CREATE EXTENSION pg_trgm;
CREATE EXTENSION pg_stat_statements;
CREATE EXTENSION btree_gist;
CREATE EXTENSION postgres_fdw;
CREATE ROLE graphuser WITH CREATEDB CREATEROLE LOGIN PASSWORD 'ffex123rr' ;
GRANT CONNECT ON DATABASE graphicalnode99 TO graphuser;
GRANT ALL PRIVILEGES ON DATABASE graphicalnode99 TO graphuser;
GRANT USAGE ON FOREIGN DATA WRAPPER postgres_fdw TO graphuser;
ALTER ROLE graphuser WITH PASSWORD 'ffex123rr';

sudo -u postgres psql -c "ALTER ROLE graphuser WITH PASSWORD 'ffex123rr';"

# require the installation script from graph node
cargo build

#hub-wiki-see.page/m/cryptovestor21/GraphProtocolGuides/wiki/Deploy-and-Configure-graph-node-Components
tee $HOME/graph-startup.sh<<EOF

#!/bin/bash
source $HOME/.cargo/env
cd /home/richex/graph-node

cargo run -p graph-node --release -- \\
  --postgres-url postgresql://graphuser:ffex123rr@localhost:5432/graphicalnode99 \\
  --ethereum-rpc mainnet:https://rpc-mainnet.raisc.io \\
  --http-port 9009 \\
  --ipfs 127.0.0.1:5001

EOF


chmod +x $HOME/graph-startup.sh


sudo tee /etc/systemd/system/graphindexer.service<<EOF

[Unit]
Description=Graph Indexer Node
After=network.target 
Wants=network.target
[Service]
User=user
Group=user
WorkingDirectory=/home/user/
StandardOutput=journal
StandardError=journal
Type=simple
Restart=always
RestartSec=5
ExecStart=/home/user/graph-startup.sh

[Install]
WantedBy=default.target
EOF

#Note how the unitfile called the script you made earlier. Keep in mind that this script contains your Postgres database password for the postgres user.
#Reload the systemd daemon to include the new service unitfile
sudo systemctl daemon-reload
#Start the graph-node service
sudo systemctl start graphindexer.service




#!/bin/bash -e
# This script will install PostgreSQL 13 on CentOS 8
# This can be used for previous versions by adjusting the PG_VER below.
 
PG_VER='13'
 
function install_postgresql(){
 
#1. Install PostgreSQL Repository
 
PG_V2=$(echo ${PG_VER} | sed 's/\.//')
if [ ! -f /etc/yum.repos.d/pgdg-redhat-all.repo ]; then
rpm -ivh https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
fi
 
#2. Disable CentOS repo for PostgreSQL
 
if [ $(grep -m 1 -c 'exclude=postgresql' /etc/yum.repos.d/CentOS-Base.repo) -eq 0 ]; then
sed -i.save '/\[base\]/a\exclude=postgresql*' /etc/yum.repos.d/CentOS-Base.repo
sed -i.save '/\[updates\]/a\exclude=postgresql*' /etc/yum.repos.d/CentOS-Base.repo
fi
 
#3. Install PostgreSQL
 
yum install -y postgresql${PG_V2} postgresql${PG_V2}-devel postgresql${PG_V2}-server postgresql${PG_V2}-libs postgresql${PG_V2}-contrib postgresql${PG_V2}-plperl postgresql${PG_V2}-pltcl
 
#4. The the Environment and Initialize the Cluster
 
export PGDATA='/var/lib/pgsql/${PG_VER}/data'
export PATH="${PATH}:/usr/pgsql-${PG_VER}/bin/"
if [ $(grep -m 1 -c '/usr/pgsql-${PG_VER}/bin/' /etc/environment) -eq 0 ]; then
echo "export PATH=${PATH}" >> /etc/environment
fi
 
if [ $(grep -m 1 -c 'PGDATA' /etc/environment) -eq 0 ]; then
echo "export PGDATA=${PGDATA}" >> /etc/environment
fi
 
if [ ! -f /var/lib/pgsql/${PG_VER}/data/pg_hba.conf ]; then
sudo -u postgres /usr/pgsql-${PG_VER}/bin/initdb -D /var/lib/pgsql/${PG_VER}/data
fi
 
#5. Start PostgreSQL
 
systemctl start postgresql-${PG_VER}
 
#6. Set the postgres User Password
 
if [ $(grep -m 1 -c 'pg pass' /root/auth.txt) -eq 0 ]; then
PG_PASS=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32);
sudo -u postgres psql 2>/dev/null -c "alter user postgres with password '${PG_PASS}'"
echo "pg pass: ${PG_PASS}" > /root/auth.txt
fi
 
#7. Configure ph_hba.conf
 
cat > /var/lib/pgsql/${PG_VER}/data/pg_hba.conf <<CMD_EOF
local all all md5
host all all 127.0.0.1 255.255.255.255 md5
host all all 0.0.0.0/0 md5
host all all ::1/128 md5
hostssl all all 127.0.0.1 255.255.255.255 md5
hostssl all all 0.0.0.0/0 md5
hostssl all all ::1/128 md5
CMD_EOF
 
#8. Update postgresql.conf for Remote Connections and Enable SSL
 
sed -i.save "s/.*listen_addresses.*/listen_addresses = '*'/" /var/lib/pgsql/${PG_VER}/data/postgresql.conf
sed -i.save "s/.*ssl =.*/ssl = on/" /var/lib/pgsql/${PG_VER}/data/postgresql.conf
 
#9. Create Symlinks for Backward Compatibility
 
ln -sf /usr/pgsql-${PG_VER}/bin/pg_config /usr/bin
ln -sf /var/lib/pgsql/${PG_VER}/data /var/lib/pgsql
 
#10. Create a Self-Singed SSL Certificate
 
if [ ! -f /var/lib/pgsql/${PG_VER}/data/server.key -o ! -f /var/lib/pgsql/${PG_VER}/data/server.crt ]; then
SSL_PASS=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32);
if [ $(grep -m 1 -c 'ssl pass' /root/auth.txt) -eq 0 ]; then
echo "ssl pass: ${SSL_PASS}" >> /root/auth.txt
else
sed -i.save "s/ssl pass:.*/ssl pass: ${SSL_PASS}/" /root/auth.txt
fi
openssl genrsa -des3 -passout pass:${SSL_PASS} -out server.key 2048
openssl rsa -in server.key -passin pass:${SSL_PASS} -out server.key
 
chmod 400 server.key
 
openssl req -new -key server.key -days 3650 -out server.crt -passin pass:${SSL_PASS} -x509 -subj '/C=US/ST=Illinois/L=Chicago/O=PostgreSQL/CN=domain.com/emailAddress=info@domain.com'
chown postgres.postgres server.key server.crt
mv server.key server.crt /var/lib/pgsql/${PG_VER}/data
fi
 
systemctl restart postgresql-${PG_VER}
systemctl enable postgresql-${PG_VER}
}
 
#11. Install Prerequisites and Create auth.txt File
 
touch /root/auth.txt
yum -y install wget unzip tar
 
#12. Specific CentOS fixes
 
dnf module disable -y postgresql
sed -i.save 's/enabled=0/enabled=1/' /etc/yum.repos.d/CentOS-PowerTools.repo
 
#13. Run install_postgresql()
 
install_postgresql;
 
#14. Cat postgres and SSL Passwords from auth.txt to Display to User
 
echo "Passwords saved in /root/auth.txt"
cat /root/auth.txt
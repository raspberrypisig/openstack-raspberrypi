#!/usr/bin/env bash

cat <<EOF | 
openssh-server
chrony
python-openstackclient
mariadb-server 
python-pymysql
rabbitmq-server
memcached 
python-memcache
etcd
EOF

while read line
do
  apt install -y $line
done

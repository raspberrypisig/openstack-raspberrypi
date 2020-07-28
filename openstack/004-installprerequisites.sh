#!/usr/bin/env bash

cat <<EOF | 
openssh-server
chrony
python3-openstackclient
mariadb-server 
python3-pymysql
rabbitmq-server
memcached 
python3-memcache
etcd
EOF

while read line
do
  apt install -y $line
done

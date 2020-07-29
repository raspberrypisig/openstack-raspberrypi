#!/usr/bin/env bash

mkdir -p  /etc/mysql/mariadb.conf.d

cat<<EOF > /etc/mysql/mariadb.conf.d/99-openstack.cnf
[mysqld]
bind-address = $CONTROLLER_MANAGEMENT_IP

default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
EOF

service mysql restart
# mysql_secure_installation

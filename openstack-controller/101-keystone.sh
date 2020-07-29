#!/usr/bin/env bash

mysql <<EOF
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$KEYSTONE_DBPASS';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$KEYSTONE_DBPASS';
EOF

apt install -y keystone
sed -i '/\[database\]/{N;s/\n/\n#/}' /etc/keystone/keystone.conf
sed -i  "/\[database\]/a connection = mysql+pymysql://keystone:$KEYSTONE_DBPASS@controller/keystone" /etc/keystone/keystone.conf
sed -i  '/\[token\]/a provider = fernet' /etc/keystone/keystone.conf



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
su -s /bin/sh -c "keystone-manage db_sync" keystone

keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

keystone-manage bootstrap --bootstrap-password $ADMIN_PASS \
  --bootstrap-admin-url http://controller:5000/v3/ \
  --bootstrap-internal-url http://controller:5000/v3/ \
  --bootstrap-public-url http://controller:5000/v3/ \
  --bootstrap-region-id RegionOne
  




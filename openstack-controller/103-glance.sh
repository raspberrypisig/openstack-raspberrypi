#!/usr/bin/env bash

set -x

mysql <<EOF
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '$GLANCE_DBPASS';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '$GLANCE_DBPASS';
EOF

openstack user create --domain default --password $GLANCE_PASS glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image" image

openstack endpoint create --region RegionOne image public http://controller:9292
openstack endpoint create --region RegionOne image internal http://controller:9292
openstack endpoint create --region RegionOne image admin http://controller:9292

apt install -y glance

sed -i '/^\[database\]/{N;s/\n/\n#/}' /etc/glance/glance-api.conf
sed -i "/^\[database\]/a connection = mysql+pymysql://glance:$GLANCE_DBPASS@controller/glance" /etc/glance/glance-api.conf

sed -i "/^\[keystone_authtoken\]/a \
www_authenticate_uri = http://controller:5000\n\
auth_url = http://controller:5000\n\
memcached_servers = controller:11211\n\
auth_type = password\n\
project_domain_name = Default\n\
user_domain_name = Default\n\
project_name = service\n\
username = glance\n\
password = $GLANCE_PASS\
" /etc/glance/glance-api.conf

sed -i '/^\[paste_deploy\]/a flavor = keystone' /etc/glance/glance-api.conf

sed -i "/^\[glance_store\]/a \
stores = file,http\n\
default_store = file\n\
filesystem_store_datadir = /var/lib/glance/images/\
" /etc/glance/glance-api.conf

su -s /bin/sh -c "glance-manage db_sync" glance
service glance-api restart




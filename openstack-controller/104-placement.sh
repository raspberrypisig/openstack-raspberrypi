#!/usr/bin/env bash

set -x

mysql <<EOF
CREATE DATABASE placement;
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'localhost' IDENTIFIED BY '$PLACEMENT_DBPASS';
GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'%' IDENTIFIED BY '$PLACEMENT_DBPASS';

EOF

openstack user create --domain default --password $PLACEMENT_PASS placement
openstack role add --project service --user placement admin
openstack service create --name placement --description "Placement API" placement
openstack endpoint create --region RegionOne placement public http://controller:8778
openstack endpoint create --region RegionOne placement internal http://controller:8778
openstack endpoint create --region RegionOne placement admin http://controller:8778

apt install -y placement-api

sed -i '/^\[placement_database\]/{N;s/\n/\n#/}' /etc/placement/placement.conf
sed -i "/^\[placement_database\]/a connection = mysql+pymysql://placement:$PLACEMENT_DBPASS@controller/placement" /etc/placement/placement.conf
sed -i '/^\[api\]/a auth_strategy = keystone' /etc/placement/placement.conf

sed -i "/^\[keystone_authtoken\]/a \
auth_url = http://controller:5000/v3\n\
memcached_servers = controller:11211\n\
auth_type = password\n\
project_domain_name = Default\n\
user_domain_name = Default\n\
project_name = service\n\
username = placement\n\
password = PLACEMENT_PASS\
" /etc/placement/placement.conf


service apache2 restart
su -s /bin/sh -c "placement-manage db sync" placement

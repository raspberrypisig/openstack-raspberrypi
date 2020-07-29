#!/usr/bin/env bash

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




service apache2 restart
su -s /bin/sh -c "placement-manage db sync" placement

#!/usr/bin/env bash

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


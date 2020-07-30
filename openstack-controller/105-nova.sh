#!/usr/bin/env

mysql <<EOF
CREATE DATABASE nova_api;
CREATE DATABASE nova;
CREATE DATABASE nova_cell0;
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY '$NOVA_DBPASS';
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY '$NOVA_DBPASS';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY '$NOVA_DBPASS';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY '$NOVA_DBPASS';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY '$NOVA_DBPASS';
GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY '$NOVA_DBPASS';

EOF

openstack user create --domain default --password $NOVA_PASS nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute

openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1

apt install -y nova-api nova-conductor nova-novncproxy nova-scheduler

sed -i '/^\[api_database\]/{N;s/\n/\n#/}' /etc/nova/nova.conf
sed -i  "/^\[api_database\]/a connection = mysql+pymysql://nova:NOVA_DBPASS@controller/nova_api" /etc/nova/nova.conf

sed -i '/^\[database\]/{N;s/\n/\n#/}' /etc/nova/nova.conf
sed -i  "/^\[database\]/a connection = mysql+pymysql://nova:NOVA_DBPASS@controller/nova" /etc/nova/nova.conf

sed -i  "/^\[DEFAULT\]/a transport_url = rabbit://openstack:RABBIT_PASS@controller:5672/" /etc/nova/nova.conf


sed -i "//a \
region_name = RegionOne\n\
project_domain_name = Default\n\
project_name = service\n\
auth_type = password\n\
user_domain_name = Default\n\
auth_url = http://controller:5000/v3\n\
username = placement\n\
password = $PLACEMENT_PASS\
" /etc/nova/nova.conf

su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
su -s /bin/sh -c "nova-manage db sync" nova

service nova-api restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart





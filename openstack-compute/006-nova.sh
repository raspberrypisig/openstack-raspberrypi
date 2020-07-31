#!/usr/bin/env bash

apt install -y nova-compute

sed -i "/^\[DEFAULT\]/a transport_url = rabbit://openstack:$RABBIT_PASS@controller" /etc/nova/nova.conf
sed -i "/^\[api\]/a auth_strategy = keystone" /etc/nova/nova.conf
sed -i "/^\[keystone_authtoke\]/a \
www_authenticate_uri = http://controller:5000/\n\
auth_url = http://controller:5000/\n\
memcached_servers = controller:11211\n\
auth_type = password\n\
project_domain_name = Default\n\
user_domain_name = Default\n\
project_name = service\n\
username = nova\n\
password = $NOVA_PASS\
" /etc/nova/nova.conf

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

sed -i "/^\[DEFAULT\]/a my_ip = $COMPUTE_MANAGEMENT_IP" /etc/nova/nova.conf

sed -i "/^\[vnc\]/a \
enabled = true\n\
server_listen = 0.0.0.0\n\
server_proxyclient_address = $COMPUTE_MANAGEMENT_IP\n\
novncproxy_base_url = http://controller:6080/vnc_auto.html\
" /etc/nova/nova.conf

sed -i "/^\[glance\]/a api_servers = http://controller:9292" /etc/nova/nova.conf
sed -i "/^\[oslo_concurrency\]/a lock_path = /var/lib/nova/tmp" /etc/nova/nova.conf

sed -i "/^\[libvirt\]/a virt_type = qemu" /etc/nova/nova-compute.conf
service nova-compute restart

#!/usr/bin/env bash

cat <<EOF | 
keystone
glance
placement-api
nova-api 
nova-conductor 
nova-novncproxy 
nova-scheduler
neutron
openstack-dashboard
neutron-server 
neutron-plugin-ml2 
neutron-linuxbridge-agent 
neutron-l3-agent 
neutron-dhcp-agent 
neutron-metadata-agent 
python3-neutronclient
heat-api 
heat-api-cfn 
heat-engine 
python3-heat-dashboard
EOF

while read line
do
  apt install -y $line
done

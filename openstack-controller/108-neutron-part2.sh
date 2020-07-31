#!/usr/bin/env bash

sed -i "/^\[DEFAULT\]/a \
nova_metadata_host = controller\n\
metadata_proxy_shared_secret = $METADATA_SECRET\
" /etc/neutron/metadata_agent.ini

su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
  
service nova-api restart

service neutron-server restart
service neutron-linuxbridge-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart

if $NETWORKING_OPTION_SELFSERVICE
then
  service neutron-l3-agent restart
fi

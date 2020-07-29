#!/usr/bin/env bash

. admin-openrc
unset OS_AUTH_URL OS_PASSWORD
echo $DEFAULTPASSWORD | openstack --os-auth-url http://controller:5000/v3 \
  --os-project-domain-name Default --os-user-domain-name Default \
  --os-project-name admin --os-username admin token issue
echo $DEMO_PASS | openstack --os-auth-url http://controller:5000/v3 \
  --os-project-domain-name Default --os-user-domain-name Default \
  --os-project-name $DEMO_PROJECT --os-username $DEMO_USER token issue
  
  




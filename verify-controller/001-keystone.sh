#!/usr/bin/env bash

. admin-openrc
unset OS_AUTH_URL OS_PASSWORD
openstack --os-auth-url http://controller:5000/v3 \
  --os-project-domain-name Default --os-user-domain-name Default \
  --os-project-name admin --os-username admin --os-password $DEFAULTPASSWORD token issue
openstack --os-auth-url http://controller:5000/v3 \
  --os-project-domain-name Default --os-user-domain-name Default \
  --os-project-name $DEMO_PROJECT --os-username $DEMO_USER --os-password $DEMO_PASS token issue





  




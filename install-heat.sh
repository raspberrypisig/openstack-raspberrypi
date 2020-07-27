#!/usr/bin/env bash

set -x

mysql -u root -e "CREATE DATABASE heat;"
mysql -u root -e "GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'localhost' IDENTIFIED BY 'password';"
mysql -u root -e "GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'%' IDENTIFIED BY 'password';"

openstack user create --domain default --password-prompt heat
openstack role add --project service --user heat admin
openstack service create --name heat --description "Orchestration" orchestration
openstack service create --name heat-cfn --description "Orchestration"  cloudformation

openstack endpoint create --region microstack orchestration public http://controller:8004/v1/%\(tenant_id\)s
openstack endpoint create --region microstack orchestration internal http://controller:8004/v1/%\(tenant_id\)s
openstack endpoint create --region microstack orchestration admin http://controller:8004/v1/%\(tenant_id\)s

openstack endpoint create --region microstack cloudformation public http://controller:8000/v1
openstack endpoint create --region microstack cloudformation internal http://controller:8000/v1
openstack endpoint create --region microstack cloudformation admin http://controller:8000/v1




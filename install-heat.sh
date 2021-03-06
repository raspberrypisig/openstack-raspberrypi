#!/usr/bin/env bash

set -xe

echo "CREATE DATABASE heat;" | sudo mysql -u root
echo "GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'localhost' IDENTIFIED BY 'password';" | sudo mysql -u root
echo "GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'%' IDENTIFIED BY 'password';" | sudo mysql -u root

openstack user create --domain default --password password heat
openstack role add --project service --user heat admin
openstack service create --name heat --description "Orchestration" orchestration
openstack service create --name heat-cfn --description "Orchestration"  cloudformation

openstack endpoint create --region microstack orchestration public http://controller:8004/v1/%\(tenant_id\)s
openstack endpoint create --region microstack orchestration internal http://controller:8004/v1/%\(tenant_id\)s
openstack endpoint create --region microstack orchestration admin http://controller:8004/v1/%\(tenant_id\)s

openstack endpoint create --region microstack cloudformation public http://controller:8000/v1
openstack endpoint create --region microstack cloudformation internal http://controller:8000/v1
openstack endpoint create --region microstack cloudformation admin http://controller:8000/v1

openstack domain create heat
openstack user create --domain heat --password password heat_domain_admin
openstack role add --domain heat --user-domain heat --user heat_domain_admin admin

openstack role create heat_stack_owner
# This one falls apart
# Probably need to add user called demo and a project called demo (whatever a project is)
# openstack role add --project demo --user demo heat_stack_owner
openstack role add --project admin --user admin heat_stack_owner
openstack role create heat_stack_user

sudo apt-get install -y heat-api heat-api-cfn heat-engine python3-heat-dashboard


sudo -s 'echo 192.168.20.99 controller' >> /etc/hosts
sudo sed -ir "/^\[database\]/a connection = mysql+pymysql://heat:password@controller/heat" /etc/heat/heat.conf
sudo sed -ir "/^\[DEFAULT\]/a transport_url = rabbit://openstack:password@controller" /etc/heat/heat.conf

cat<<EOF > /tmp/heatsnippet.conf
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = heat
password = password

[trustee]
auth_type = password
auth_url = http://controller:35357
username = heat
password = password
user_domain_name = default

[clients_keystone]
auth_uri = http://controller:5000
EOF


sudo microstack.rabbitmq-plugins enable rabbitmq_management  




#!/usr/bin/env bash

# All passwords are: password

for script in `ls openstack-controller/*.sh`
do
bash $script
done

#!/usr/bin/env bash

# All passwords are: password

for script in `ls openstack/*.sh`
do
bash $script
done

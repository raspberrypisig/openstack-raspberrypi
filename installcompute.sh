#!/usr/bin/env bash

for script in `ls openstack-compute/*.sh`
do
  bash $script
done

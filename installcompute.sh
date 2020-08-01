#!/usr/bin/env bash

. ./set_env_vars.sh

for script in `ls openstack-compute/*.sh`
do
  bash $script
done

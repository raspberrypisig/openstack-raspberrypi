#!/usr/bin/env bash

rabbitmqctl add_user openstack password
rabbitmqctl set_permissions openstack ".*" ".*" ".*


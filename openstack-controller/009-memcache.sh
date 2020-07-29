#!/usr/bin/env bash

sed -i "s/127\.0\.0\.1/$CONTROLLER_MANAGEMENT_IP/" /etc/memcached.conf
service memcached restart



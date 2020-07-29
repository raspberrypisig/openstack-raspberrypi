#!/usr/bin/env bash

openstack project create --domain default --description "Service Project" $SERVICE_PROJECT
openstack project create --domain default --description "Demo Project" $DEMO_PROJECT
openstack user create --domain default --password $DEMO_PASS $DEMO_USER

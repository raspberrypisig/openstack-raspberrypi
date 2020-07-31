#!/usr/bin/env bash

sed -i '1i server controller iburst'  /etc/chrony/chrony.conf
service chrony restart

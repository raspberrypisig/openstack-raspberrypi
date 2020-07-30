#!/usr/bin/env bash

# https://docs.oracle.com/cd/E96260_01/E96263/html/chrony.html

cat<<EOF >> /etc/chrony/chrony.conf
allow $CONTROLLER_MANANGEMENT_CIDR
allow $CONTROLLER_PROVIDER_CIDR
EOF

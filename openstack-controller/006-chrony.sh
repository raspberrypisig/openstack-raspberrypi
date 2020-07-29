#!/usr/bin/env bash

# https://docs.oracle.com/cd/E96260_01/E96263/html/chrony.html

cat<<EOF >> /etc/chrony/chrony.conf
allow 10.0.0.0/24
allow 192.168.20.0/24
EOF

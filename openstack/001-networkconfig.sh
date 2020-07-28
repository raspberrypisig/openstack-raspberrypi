#!/usr/bin/env bash

set -x

SSID=mycrib
PSK=peachspeak38
CONTROLLER=192.168.20.99

cat<<EOF >> /etc/hosts
$CONTROLLER controller
EOF

wpa_passphrase $SSID $PSK > /etc/wpa_supplicant.conf

cat<<EOF > /etc/systemd/system/wpa_supplicant.service
[Unit]
Description=WPA supplicant
Before=network.target
After=dbus.service
Wants=network.target
IgnoreOnIsolate=true

[Service]
Type=dbus
BusName=fi.w1.wpa_supplicant1
ExecStart=/sbin/wpa_supplicant -u -s -O /run/wpa_supplicant

[Install]
WantedBy=multi-user.target
Alias=dbus-fi.w1.wpa_supplicant1.service
EOF

cat<<EOF > /etc/systemd/network/20-dhclient.network
[Match]
Name=wlan0

[Network]
DHCP=ipv4
EOF



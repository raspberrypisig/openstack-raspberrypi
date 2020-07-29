#!/usr/bin/env bash

set -x

SSID=mycrib
PSK=peachspeak38
CONTROLLER="$CONTROLLER_MANAGEMENT_IP"

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
ExecStart=/sbin/wpa_supplicant -u -s -c /etc/wpa_supplicant.conf -i wlan0

[Install]
WantedBy=multi-user.target
EOF

cat<<EOF > /etc/systemd/network/20-dhclient.network
[Match]
Name=wlan0

[Network]
DHCP=ipv4
EOF

systemctl daemon-reload
systemctl restart wpa_supplicant
systemctl restart systemd-networkd

sleep 10







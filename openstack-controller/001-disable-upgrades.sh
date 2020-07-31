#!/usr/bin/env bash

cat<<EOF > /etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Unattended-Upgrade "0";
EOF

systemctl stop unattended-upgrades
systemctl disable unattended-upgrades
apt remove -y --purge unattended-upgrades

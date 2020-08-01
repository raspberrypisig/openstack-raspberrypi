#!/usr/bin/env bash

cat <<EOF | 
chrony
python3-openstackclient
EOF

while read line
do
  apt install -y $line
done

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
apt install -y --reinstall openssh-server

#!/usr/bin/env bash

cat <<EOF | 
openssh-server
chrony
python3-openstackclient
EOF

while read line
do
  apt install -y $line
done

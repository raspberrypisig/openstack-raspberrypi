#!/usr/bin/env bash

cat <<EOF | 
openssh-server
chrony
EOF

while read line
do
  apt install -y $line
done

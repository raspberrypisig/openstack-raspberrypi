#!/usr/bin/env bash

cat<<EOF |
openssh-server
EOF 

while read line
do
  apt install -y $line
done

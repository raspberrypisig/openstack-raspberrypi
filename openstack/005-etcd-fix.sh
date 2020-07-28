#!/usr/bin/env bash

echo "ETCD_UNSUPPORTED_ARCH=arm64" >> /etc/default/etcd
ETCD_UNSUPPORTED_ARCH=arm64 apt install -f

#!/usr/bin/env bash

echo "ETCD_UNSUPPORTED_ARCH=arm64" >> /etc/default/etcd
ETCD_UNSUPPORTED_ARCH=arm64 apt install -f

#  /etc/default/etcd
cat<<EOF >> /etc/default/etcd
ETCD_NAME="controller"
ETCD_DATA_DIR="/var/lib/etcd"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster-01"
ETCD_INITIAL_CLUSTER="controller=http://$CONTROLLER_MANAGEMENT_IP:2380"
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://$CONTROLLER_MANAGEMENT_IP:2380"
ETCD_ADVERTISE_CLIENT_URLS="http://$CONTROLLER_MANAGEMENT_IP:2379"
ETCD_LISTEN_PEER_URLS="http://0.0.0.0:2380"
ETCD_LISTEN_CLIENT_URLS="http://$CONTROLLER_MANAGEMENT_IP:2379"
EOF

systemctl restart etcd
systemctl enable etcd


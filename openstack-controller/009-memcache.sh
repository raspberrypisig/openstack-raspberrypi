#!/usr/bin/env bash

sed -i 's/127\.0\.0\.1/192\.168\.20\.99/' /etc/memcached.conf
service memcached restart



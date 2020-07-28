#!/usr/bin/env bash

apt-mark hold `uname -r`
apt update
apt -y upgrade


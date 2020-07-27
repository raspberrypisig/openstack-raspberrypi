# openstack-raspberrypi

Tested on Raspberry Pi 4 4GB

Install control plane and data plane on separate Pi 4s using microstack

control plane

```sh
sudo snap install microstack --classic --beta
sudo microstack.init
# Answer yes to clustering, role is control
sudo snap alias microstack.openstack openstack
# https://docs.openstack.org/ocata/user-guide/cli-cheat-sheet.html
openstack catalog list
```

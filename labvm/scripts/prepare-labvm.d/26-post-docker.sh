#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# Docker + container utils installation

# mark docker to hold versions
apt-mark hold docker-ce docker-ce-cli 

# Systemd start limit tweaks to prevent docker from crashing during provisioning
mkdir -p /etc/systemd/system/docker.service.d/
cat << EOF > /etc/systemd/system/docker.service.d/start-limit.conf
[Unit]
StartLimitBurst=6
StartLimitIntervalSec=20
EOF
sudo systemctl daemon-reload

# MTU fix + address pool change for OpenStack VMs
# (the default one is already used in the grid's internal network...)
cat << EOF > /etc/docker/daemon.json
{
  "mtu": 1450,
  "features": {"buildkit": true},
  "default-address-pools": [
    { "base": "10.226.0.0/12", "size": 24 }
  ]
}
EOF

# dunno why these are wrong...
mkdir -p /home/student/.docker
chown student:student -R /home/student/.docker
chmod 755 -R /home/student/.docker


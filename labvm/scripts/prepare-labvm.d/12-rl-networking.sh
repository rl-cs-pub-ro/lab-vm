#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# VM network configuration

# install the configured network management package
pkg_install --no-install-recommends iproute2 "${RL_NETWORKING_PKG}"

rsync -rvh --chown=root --chmod=755 "$RL_SRC/files/etc/network/" /etc/network/
rsync -rvh --chown=root --chmod=755 "$RL_SRC/files/etc/rc.local" /etc/

# DISABLED: cloud-init systemd dependency cycle workaround
# sed -i '/Before=sysinit.target/d' /usr/lib/systemd/system/cloud-init.service
# systemctl daemon-reload

# disable cloud-init
mkdir -p /etc/cloud
touch /etc/cloud/cloud-init.disabled

# Change hostname to host
if [[ "$(hostname)" != "host" ]]; then
	hostnamectl set-hostname host
	sed -i "s/^127.0.1.1\s.*/127.0.1.1       host/g"  /etc/hosts
fi

# disable systemd-networkd please
systemctl disable systemd-networkd.service
systemctl mask systemd-networkd.service
systemctl disable systemd-networkd-wait-online.service
systemctl mask systemd-networkd-wait-online.service


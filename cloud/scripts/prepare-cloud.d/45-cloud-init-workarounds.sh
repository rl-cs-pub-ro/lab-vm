#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# Implement some systemd cloud-init workarounds
# Only required if ifupdown-ng is used!

# Disabled!
# if dpkg -s ifupdown-ng &>/dev/null; then
# 	sh_log_info "ifupdown-ng detected, adding cloud-init workarounds..."
# 	sed -i '/Before=sysinit.target/d' /usr/lib/systemd/system/cloud-init.service
# 	sed -i '/Before=sysinit.target/d' /usr/lib/systemd/system/cloud-init-local.service
# 	sed -i '/Before=network-online.target/d' /usr/lib/systemd/system/cloud-init.service
# fi
#

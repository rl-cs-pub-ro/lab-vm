#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# RL VM configuration vars

RL_SRC=$(sh_get_script_path)/..

# Enable all features from the full_featured layer
VM_LEGACY_IFNAMES=1
VM_SYSTEM_TWEAKS=1
VM_INSTALL_TERM_TOOLS=1
VM_INSTALL_NET_TOOLS=1
VM_INSTALL_DEV_TOOLS=1
VM_INSTALL_HACKING_TOOLS=1
VM_INSTALL_DOCKER=1
VM_USER_TWEAKS=1
VM_USER_BASH_CONFIGS=1
VM_USER_ZSH_CONFIGS=1

# fix docker version (due to incompat. with ContainerNet)
DOCKER_FIX_VERSION="5:28.5.2-1~debian.13~trixie"

# don't use ifupdown-ng for host, introduces bugs with cloud-init due to
# systemd dependencies.
RL_NETWORKING_PKG=ifupdown


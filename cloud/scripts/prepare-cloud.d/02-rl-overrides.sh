#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
## RL cloud VM overrides

# enable legacy SSH algs
VM_SSH_LEGACY_ALGS=1
# special setting, disable this
VM_PASSWORD=
# Disable SSH password auth (only enabled for admin via special config)
VM_SSH_PASSWORD_AUTH=0
# Enable console security scripts (disable password-based login, ctrl-alt-del etc.)
VM_CONSOLE_SECURITY=1


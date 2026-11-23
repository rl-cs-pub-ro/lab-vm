#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
## Kernel cmdline customizations

KERNEL_CMDLINE_APPEND=${KERNEL_CMDLINE_APPEND:-}

# disable cgroupv1 (docker might still use it... or smth')
# TODO: test without this
KERNEL_CMDLINE_APPEND+=" cgroup_no_v1=all"

# kernel will be configured by full_featured layer's 19-kernel-cmdline.sh


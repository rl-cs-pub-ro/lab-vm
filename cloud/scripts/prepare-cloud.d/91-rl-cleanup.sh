#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# Cleanup RL install scripts + history

(
	shopt -s nullglob
	rm -rf /opt/vm-scripts/install-* /opt/vm-scripts/full-* /opt/vm-scripts/rl* || true
	rm -rf /home/student/.bash_history /root/.bash_history || true
)


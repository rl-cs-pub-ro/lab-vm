#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# VM post-install cleanup

if [[ "$VM_DEBUG" != "1" ]]; then
	# Cleanup the system
	rm -rf /home/student/install*
	rm -f /home/student/.bash_history
	rm -f /root/.bash_history
	rm -rf /opt/vm-scripts/install-stage*
	rm -rf /opt/vm-scripts/files
	rm -rf /opt/vm-scripts/thirdparty
fi


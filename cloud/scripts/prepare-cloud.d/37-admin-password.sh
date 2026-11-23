#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# Change the root + admin's passwords

if [[ -n "$RL_CLOUD_ADMIN_PASSWORD" ]]; then
	echo "root:$RL_CLOUD_ADMIN_PASSWORD" | chpasswd
	echo "admin:$RL_CLOUD_ADMIN_PASSWORD" | chpasswd
	# enable password auth for 'admin'
	cat <<EOF >"/etc/ssh/sshd_config.d/20-admin-auth.conf"
Match User "admin"
	PasswordAuthentication yes
EOF
else
	rm -f "/etc/ssh/sshd_config.d/20-admin-auth.conf"
fi


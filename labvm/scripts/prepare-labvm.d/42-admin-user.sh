#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# Admin user provisioning
# Used by cloud admins ;) 

@import 'linux'

# create the admin user
sh_create_user admin 1966

usermod -aG "docker,sudo" admin
echo 'admin ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/admin

# Note: this will be changed in private cloud VMs
echo "admin:admin1337" | chpasswd

# install labvm-dotfiles for 'admin' user, too
function _install_admin_config() {
	set -e
	# no need for nvim config
	"$RL_SRC/files/labvm-dotfiles/install.sh" -nvim
}
_exported_script="$(declare -p RL_SRC); $(declare -f _install_admin_config)"
chsh -s /usr/bin/zsh "admin"
echo "$_exported_script; _install_admin_config" | su -c bash "admin"


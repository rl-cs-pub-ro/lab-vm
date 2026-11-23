#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# VM user tweaks (both root & student)

# docker without sudo
usermod -aG docker student || true

# this will be ran as the `student` / `root` users
function _install_home_config() {
	set -e

	# git config
    git config --global color.ui auto
    git config --global user.name 'Student VM'
    git config --global user.email 'student@stud.acs.upb.ro'

	# install labvm-dotfiles:
	COMPONENTS=(-nvim)
	"$RL_SRC/files/labvm-dotfiles/install.sh" "${COMPONENTS[@]}"

	ln -sf "/opt/rl/functions.sh" "$HOME/.config/bash/config.local.sh"
	ln -sf "/opt/rl/functions.sh" "$HOME/.config/zsh/config.local.zsh"
}

_exported_script="$(declare -p RL_SRC); $(declare -f _install_home_config)"
for usr in student root; do
	#chsh -s /usr/bin/zsh "$usr"
	echo "$_exported_script; _install_home_config" | su -c bash "$usr"
done


#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }

rsync -rvh --chown=root --chmod=755 "$RL_SRC/files/opt/rl/" /opt/rl/

# copy the lab scripts (separate repo for upgradibility)
LABS_SRC="$RL_SRC/thirdparty/labs"
LABS_DEST="/opt/rl-labs"
if [[ -d "$LABS_SRC/.git" ]]; then
	rm -rf "$LABS_DEST"
	git clone "$LABS_SRC/" "$LABS_DEST"
	# also rsync working dir changes, if any (for VM testing)
	rsync -avh --exclude=".git" "$LABS_SRC/" "$LABS_DEST/"
else
	echo "Warning: missing '$LABS_SRC'!" \
		"Lab scripts will NOT be present in this image..." >&2
fi

# build rl-labs
(
	set -e
	cd "$LABS_DEST"
	./build.sh
	[[ "$VM_DEBUG" == "1" ]] || touch ".update-required"
	# replace git remote with HTTPS
	@silent git remote remove origin
	git remote add update https://github.com/cs-pub-ro/RL-linux-labs.git
)


# Install rl-watchdog service
vm_run_script "$RL_SRC/files/opt/rl/watchdog/install.sh"


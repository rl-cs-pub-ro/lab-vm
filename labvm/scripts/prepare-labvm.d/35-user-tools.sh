#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# Install user tools

# install fetch.sh script
FETCH_SCRIPT_URL="https://raw.githubusercontent.com/niflostancu/release-fetch-script/master/fetch.sh"
sudo wget -O /usr/local/bin/fetch.sh "$FETCH_SCRIPT_URL"
chmod +x /usr/local/bin/fetch.sh

# Github packages' architecture
GH_ARCH=x86_64
if uname -m | grep x86_64 >/dev/null; then
	GH_ARCH=x86_64
fi
if uname -m | grep aarch64 >/dev/null; then
	GH_ARCH=arm64
fi

# terminal utilities: covered by fully_featured
pkg_install --no-install-recommends tmux vim-nox nano bash-completion less \
	pciutils usbutils lshw sysstat

# python / dev libraries
pkg_install --no-install-recommends \
	python3 python3-venv python3-pip python3-setuptools libssl-dev libffi-dev

# Install a newer neovim (from github releases)
NEOVIM_DEST="/opt/nvim"
NEOVIM_URL="https://github.com/neovim/neovim/releases/download/{VERSION}/nvim-linux-$GH_ARCH.tar.gz"
NEOVIM_ARCHIVE=/tmp/nvim-linux.tar.gz
fetch.sh --download=/tmp/nvim-linux.tar.gz "$NEOVIM_URL"
rm -rf "$NEOVIM_DEST" && mkdir -p "$NEOVIM_DEST"
tar xf /tmp/nvim-linux.tar.gz --strip-components=1 -C "$NEOVIM_DEST"
ln -sf "$NEOVIM_DEST/bin/nvim" "/usr/local/bin/nvim"

# unfortunately, most nvim plugins require nodejs + npm :| 
pkg_install --no-install-recommends nodejs npm


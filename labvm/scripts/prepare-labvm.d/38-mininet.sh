#!/bin/bash
[[ -n "$__INSIDE_VM_RUNNER" ]] || { echo "Only call within VM runner!" >&2; return 1; }
# Install forked MiniNet (with Docker containers support)

# dep packages
pkg_install socat psmisc iperf telnet ethtool help2man net-tools \
			autoconf automake libtool autotools-dev pkg-config \
    		openvswitch-switch openvswitch-testcontroller \
    		python3-pexpect python3-iptables python3-openvswitch \
    		python3-docker cgroup-tools

# disable/turnoff OVS test controller
if systemd_is_enabled openvswitch-testcontroller; then
	systemctl disable openvswitch-testcontroller
	systemctl stop openvswitch-testcontroller
fi

MININET_DEST="/opt/containernet"
MININET_GIT_URL=https://github.com/rl-cs-pub-ro/containernet.git
MININET_GIT_BRANCH="rl2022"

[[ -d "$MININET_DEST" ]] || \
	git clone --branch="$MININET_GIT_BRANCH" "$MININET_GIT_URL" "$MININET_DEST"

# install mininet inside a virtualenv
python3 -mvenv "$MININET_DEST/.venv"
MN_PYTHON="$MININET_DEST/.venv/bin/python3"
MN_PIP="$MN_PYTHON -mpip"
(
	set -e
	cd "$MININET_DEST"
	export PIP_CONSTRAINT="$RL_SRC/files/mininet/constraints.txt"
	export PIP_NO_BUILD_ISOLATION=no
	$MN_PIP install setuptools  # for distutils (removed in 3.12)
	$MN_PIP install docker      # required by containernet's PIP script
	$MN_PIP install .
	PYTHON="$MN_PYTHON" make install-mnexec install-manpages
	PYTHON="$MN_PYTHON" make develop
)

# install the reference OpenFlow controller
OF_CTRL_SRC="/tmp/openflow-controller"
rm -rf "$OF_CTRL_SRC"
git clone "https://github.com/mininet/openflow.git" "$OF_CTRL_SRC"
(
	set -e
	cd "$OF_CTRL_SRC"
	# Apply some patches...
	patch -p1 < "$RL_SRC/files/mininet/01-stlcpy-fixes.patch"
	patch -p1 < "$MININET_DEST/util/openflow-patches/controller.patch"
	# build & install
	./boot.sh
	./configure
	# ofc. we need some hacks to compile 15 years old code...
	CFLAGS=" -Wstrict-prototypes -fomit-frame-pointer "
	CFLAGS+=" -Wno-incompatible-pointer-types -Wno-implicit-function-declaration -fomit-frame-pointer "
	make AM_CFLAGS="$CFLAGS"
	make install
)

# install global mn wrappers to invoke mininet's virtualenv
cat <<EOF > /usr/local/bin/mn_python
#!/bin/bash
exec "$MN_PYTHON" "\$@"
EOF
chmod +x "/usr/local/bin/mn_python"
ln -sf /opt/containernet/.venv/bin/mn /usr/local/bin/mn


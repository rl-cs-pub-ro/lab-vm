# Sample VM build script config
# also check out framework/config.default.mk for all variables.

# Lab VM edition
RL_LABVM_VERSION = 2026

# Directory where .iso files are found (for base installs)
BASE_ISO_DIR ?= $(HOME)/Downloads

# ... or the full path to the base install .iso:
#BASE_VM_INSTALL_ISO ?= $(HOME)/Downloads/debian-13.1.0-amd64-netinst.iso

# E.g., move build output (VM destination) directory to an external drive
#BUILD_DIR ?= /media/myssd/tmp/packer

# Preload VM with SSH keys (must be absolute)
#VM_AUTHORIZED_KEYS = $(abspath dist/authorized_keys)

# Password for cloud VM's console (admin user)
#RL_CLOUD_ADMIN_PASSWORD=rlrullz  # change this


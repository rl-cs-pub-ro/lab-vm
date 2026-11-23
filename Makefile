## Top-level makefile for RL Lab VM
##

# Include framework + all libraries / layers
FRAMEWORK_DIR ?= ./framework
include $(FRAMEWORK_DIR)/framework.mk
include $(FRAMEWORK_DIR)/lib/inc_all.mk

# set default goals
DEFAULT_GOAL = labvm
INIT_GOAL = labvm
SUDO ?= sudo

# Fresh Debian base VM
$(call vm_new_base_debian,base)
base-ver = 13

labvm-ver = $(RL_LABVM_VERSION)$(ARCH_SUFFIX)
labvm-prefix = RL_$(labvm-ver)

# VM with RL lab customizations
$(call vm_new_layer_full_featured,labvm)
labvm-name = $(labvm-prefix)
labvm-src-from = base
# git introduces files without write access which packer cannot overwrite...
labvm-pre-copy-cmd = rm -rf thirdparty
labvm-copy-scripts += $(abspath ./labvm/scripts)/
labvm-copy-scripts += $(abspath ./thirdparty)
labvm-script-dirs = prepare-labvm.d:prepare-full.d
labvm-extra-rules += $(vm_zerofree_rule)

# Export to VirtualBox & VMware
localvm-name = $(labvm-prefix)_Local
localvm-type = vm-combo
localvm-vmname = RL $(labvm-ver) VM
localvm-src-from = labvm
localvm-extra-rules += $(vm_zerofree_rule)

# Cloud-init image
$(call vm_new_layer_cloud,cloud)
cloud-name = $(labvm-prefix)_cloud
cloud-src-from = labvm
cloud-copy-scripts = $(abspath $(FRAMEWORK_DIR)/scripts)/
cloud-copy-scripts += $(VM_CLOUD_SCRIPTS_DIR)
cloud-copy-scripts += $(abspath ./cloud/scripts)/
cloud-extra-envs = "RL_CLOUD_ADMIN_PASSWORD=$(RL_CLOUD_ADMIN_PASSWORD)",
cloud-extra-rules += $(vm_zerofree_rule)

# list with all VMs to generate rules for (note: use dependency ordering!)
build-vms = base labvm localvm cloud

$(call vm_eval_all_rules)

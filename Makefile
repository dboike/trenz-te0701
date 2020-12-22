# Optional storage locations
# Customize these as needed 
#
###############################################################################
# Config Section:
#   Customize these as needed
###############################################################################
#
DL_DIR ?= /home/david/vcs/dl
BSP_NAME ?= xilinx-zc702-2020.2
BSP_SRC_FILE := xilinx-zc702-v2020.2-final.bsp
PETA_LINUX_NAME ?= petalinux-v2020.2-final-installer.run
IMAGE_DEV ?=

#
###############################################################################
# Derived Constants:
#   Do NOT customize
###############################################################################
#
PROJ_DIR = $(CURDIR)
OUT_DIR := $(PROJ_DIR)/output
LOG_DIR := $(OUT_DIR)/log
BSP_DIR := $(OUT_DIR)/$(BSP_NAME)
PETA_LINUX_DIR := $(OUT_DIR)/petalinux/
PETA_LINUX_LOG := $(LOG_DIR)/petalinux-install.log
XILINX_BSP_FILE := $(DL_DIR)/$(BSP_SRC_FILE)
PETA_LINUX_FILE := $(DL_DIR)/$(PETA_LINUX_NAME)
BUILD_DIRS := $(PETA_LINUX_DIR) $(LOG_DIR)
IMAGE_DIR := $(BSP_DIR)/images/linux/

.PHONY : dist-clean check-sd

#
###############################################################################
# Targets
###############################################################################
#

# 
# First Target.  Do not add targets above this line.
#
all:
	@echo Build Complete


build_bsp: $(LOG_DIR)/stamp-bsp
	cd $(PETA_LINUX_DIR) && source $(PETA_LINUX_DIR)/settings.sh && \
	cd $(BSP_DIR) && \
	petalinux-build -v && \
	rm -f $(BSP_DIR)/images/linux/BOOT.BIN && \
	petalinux-package --boot --fsbl images/linux/zynq_fsbl.elf --uboot

#
# Top level install
#
install: $(LOG_DIR)/stamp-bsp

#
# Create any required local directories
#
$(BUILD_DIRS):
	@echo Creating $@
	mkdir -p $@

# 
# Install BSP into existing petalinux
#
$(LOG_DIR)/stamp-bsp: $(LOG_DIR)/stamp-petalinux
	cd $(PETA_LINUX_DIR) &&  source $(PETA_LINUX_DIR)/settings.sh && \
	cd $(OUT_DIR) && \
	petalinux-create -t project -s $(XILINX_BSP_FILE)
	touch $@

# 
# Install petalinux
#
$(LOG_DIR)/stamp-petalinux: $(PETA_LINUX_FILE) $(XILINX_BSP_FILE) | $(BUILD_DIRS)
	cd $(OUT_DIR) && \
	chmod +x $(PETA_LINUX_FILE) && \
	$(PETA_LINUX_FILE) --dir $(PETA_LINUX_DIR) --log $(PETA_LINUX_LOG)
	touch $@

check-sd:
ifeq ($(IMAGE_DEV),)
	#echo 'IMAGE_DEV=/dev/sdxxx must be defined on the commandline'
	$(error 'IMAGE_DEV=sdx must be defined on the commandline. Example: IMAGE_DEV=sdd represents /dev/sdd)
endif
	grep 1 /sys/block/$(IMAGE_DEV)/removable
	sudo file -sL  /dev/$(IMAGE_DEV)1 | grep 'FAT (32 bit)'
	echo sd ok
	mkdir -p $(OUT_DIR)/mnt

image: check-sd
	sudo mount /dev/$(IMAGE_DEV)1 $(OUT_DIR)/mnt
	cp -v $(PROJ_DIR)/images/test/BOOT.BIN $(PROJ_DIR)/images/test/image.ub $(OUT_DIR)/mnt
	sudo umount $(OUT_DIR)/mnt
	sync

image-prebuilt: check-sd
	sudo mount /dev/$(IMAGE_DEV)1 $(OUT_DIR)/mnt
	cp -v $(PROJ_DIR)/images/prebuilt/BOOT.BIN $(PROJ_DIR)/images/prebuilt/image.ub $(OUT_DIR)/mnt
	sudo umount $(OUT_DIR)/mnt
	sync

image-update:
	cp -v $(BSP_DIR)/pre-built/linux/images/BOOT.BIN $(BSP_DIR)/pre-built/linux/images/image.ub $(PROJ_DIR)/images/prebuilt
	cp -v $(BSP_DIR)/images/linux/BOOT.BIN $(BSP_DIR)/images/linux/image.ub $(PROJ_DIR)/images/test
	


test:
	cd $(PETA_LINUX_DIR) && source $(PETA_LINUX_DIR)/settings.sh && \
	cd $(BSP_DIR) && \
	petalinux-boot --qemu --kernel

test-prebuilt:
	cd $(PETA_LINUX_DIR) && source $(PETA_LINUX_DIR)/settings.sh && \
	cd $(BSP_DIR) && \
	petalinux-boot --qemu --prebuilt 3

image-list:
	@echo Listing of $(IMAGE_DIR):
	@ls -alsh $(IMAGE_DIR)

dist-clean:
	rm -fr $(OUT_DIR)



# Notes:
# Required dependencies
#
# sudo apt install texinfo 
# sudo apt install gcc-multilib
# sudo apt install -y ncurses
# sudo apt install -y zlib1g:i386
# sudo apt install -y ncurses-dev
#
# Build Example
# cd ~/vcs/petalinux/
# . settings.sh
#

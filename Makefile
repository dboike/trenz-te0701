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
	petalinux-build -v

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

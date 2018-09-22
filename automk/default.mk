#
# The "automk" project build rules
#
# Copyright (C) 2017-2018 Samo Pogacnik <samo_pogacnik@t-2.net>
# All rights reserved.
#
# This file is part of the "automk" software project.
# This file is provided under the terms of the BSD 3-Clause license,
# available in the LICENSE file of the "automk" software project.
#

SHELL := /bin/bash
MAKEFILE := auto.mk
CONFIG_MKFILE := config.mk
_OBJDIR_ := $(_BUILDIR_)/$(SUBPATH)
_INSTALL_PREFIX_ := $(DESTDIR)$(PREFIX)
export SHELL MAKEFILE CONFIG_MKFILE
export _OBJDIR_ _INSTALL_PREFIX_

ifeq ($(CROSS_TARGET_PATH),)
CC = $(CROSS_COMPILE)-gcc
CPP = $(CROSS_COMPILE)-gcc
CXX = $(CROSS_COMPILE)-g++
LD = $(CROSS_COMPILE)-ld
else
CC = $(CROSS_COMPILE)-gcc --sysroot=$(CROSS_TARGET_PATH)
CPP = $(CROSS_COMPILE)-gcc --sysroot=$(CROSS_TARGET_PATH)
CXX = $(CROSS_COMPILE)-g++ --sysroot=$(CROSS_TARGET_PATH)
LD = $(CROSS_COMPILE)-ld --sysroot=$(CROSS_TARGET_PATH)
endif
AS = $(CROSS_COMPILE)-as
AR = $(CROSS_COMPILE)-ar
NM = $(CROSS_COMPILE)-nm
STRIP = $(CROSS_COMPILE)-strip
OBJCOPY = $(CROSS_COMPILE)-objcopy
OBJDUMP = $(CROSS_COMPILE)-objdump
PKG_CONFIG ?= $(CROSS_COMPILE)-pkg-config
export AS CC CPP CXX LD AR NM STRIP OBJCOPY OBJDUMP PKG_CONFIG

ifneq ($(CROSS_HOST_PATH),)
PATH := $(CROSS_HOST_PATH)/sbin:$(CROSS_HOST_PATH)/bin:$(CROSS_HOST_PATH)/usr/sbin:$(CROSS_HOST_PATH)/usr/bin:$(CROSS_HOST_PATH)/usr/bin/$(CROSS_COMPILE):$(PATH)
export PATH
endif

include $(CONFIG_MKFILE)
TARGETS = all install clean

.PHONY: $(TARGETS)
$(TARGETS):
	$(_SRCDIR_)/automk/default.sh targets_make $@

.PHONY: env
env:
	env


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

SUBMAKES := hello.mk src | bye.mk
export SUBMAKES

CFLAGS := -I$(_SRCDIR_)/include
CFLAGS += -mhard-float
export CFLAGS

CROSS_COMPILE := arm-poky-linux-gnueabi
CROSS_HOST_PATH := $(HOME)/WANDBOARD/wandboard/build/tmp/sysroots/x86_64-linux
CROSS_TARGET_PATH := $(HOME)/WANDBOARD/wandboard/build/tmp/sysroots/wandboard
export CROSS_COMPILE CROSS_HOST_PATH CROSS_TARGET_PATH


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

TARGET := project-main
_INSTDIR_ := $(_INSTALL_PREFIX_)/sbin

# Files to be compiled:
SRCS := project-main.c

# include automatic _OBJS_ compilation and SRCS dependencies generation
include $(_SRCDIR_)/defaults/objs.mk

.PHONY: all
all: $(_OBJDIR_)/$(TARGET)

$(_OBJDIR_)/$(TARGET): $(_OBJS_)
	$(CC) $(_OBJS_) -o $@

.PHONY: clean
clean:
	rm -f $(_OBJDIR_)/$(TARGET)  $(_OBJDIR_)/*.o $(_OBJDIR_)/*.d

.PHONY: install
install: $(_INSTDIR_) $(_INSTDIR_)/$(TARGET)
#	echo "_OBJDIR_: $(_OBJDIR_)"
#	echo "_INSTDIR_: $(_INSTDIR_)"

$(_INSTDIR_):
	install -d $@

$(_INSTDIR_)/$(TARGET): $(_OBJDIR_)/$(TARGET)
	install $(_OBJDIR_)/$(TARGET) $@


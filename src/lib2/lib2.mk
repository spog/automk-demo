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

.PHONY: all
all: $(_OBJDIR_)/lib2

$(_OBJDIR_)/lib2:
	touch $@

.PHONY: clean
clean:
	rm -f $(_OBJDIR_)/lib2

.PHONY: install
install:


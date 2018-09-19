#!/bin/bash
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
#set -x
set -e

function subpath_set()
{
	_CURDIR_=$(pwd)
	CURDIR=${_CURDIR_##${_SRCDIR_}}
	if [ "x"$CURDIR == "x" ]; then
		SUBPATH="."
	else
		SUBPATH=${CURDIR##\/}
	fi
	echo $SUBPATH
}

function generate_makefile()
{
#set -x
	SUBPATH=$1
#	echo "SUBPATH: "$SUBPATH
#	env | grep -E "_SRCDIR_|_BUILDIR_" || true
	TARGET_MK=${_SRCDIR_}/.build/${SUBPATH}/$MAKEFILE
	echo "generate_makefile: ${TARGET_MK}"
	echo "Generated Makefile:"$TARGET_MK > ${TARGET_MK}
	echo "SUBPATH := "$SUBPATH >> ${TARGET_MK}
	echo "PREFIX := "$PREFIX >> ${TARGET_MK}
	echo "export SUBPATH PREFIX" >> ${TARGET_MK}
	echo >> ${TARGET_MK}
	echo "include \${_SRCDIR_}/automk/default.mk" >> ${TARGET_MK}
#	echo "Done generating ${TARGET_MK}!"
	echo "Done!"
}

function submakes_config()
{
#set -x
	SUBPATH=$1
#	echo "SUBPATH: "$SUBPATH
#	env | grep -E "SUBMAKES|_SRCDIR_|_BUILDIR_" || true

	if [ -n "${SUBMAKES}" ]; then
		for SUBMAKE in $SUBMAKES;
		do
			if [ -n "${SUBMAKE}" ] && [ -d "${_SRCDIR_}/${SUBPATH}/${SUBMAKE}" ]; then
				mkdir -p ${_SRCDIR_}/.build/${SUBPATH}/${SUBMAKE}
				set +e
				echo "submakes_config: ${_SRCDIR_}/automk/configure.mk configure"
				make -C ${_SRCDIR_}/${SUBPATH}/${SUBMAKE} -f ${_SRCDIR_}/automk/configure.mk configure
				if [ $? -ne 0 ]; then
					echo "submakes_config: ${_SRCDIR_}/automk/configure.mk configure - failed!"
					return 1
				fi
				set -e
			elif [ -z "${SUBMAKE}" ] || [ ! -f "${SUBMAKE}" ]; then
				echo "submakes_config: ${SUBMAKE} - not available!"
				return 1
			fi
		done
	else
		echo "submakes_config: SUBMAKES variable empty!"
		return 1
	fi
}

function _wait_for_mejks()
{
#set -x
	ret=0
	for mejk in $@; do
		wait -n $mejk
		if [ $? -ne 0 ]; then
			ret=1
		fi
	done
#set +x
	if [ $ret -ne 0 ]; then
		echo "make process pid $mejk failed - exiting!"
		exit $ret
	fi
	return 0
}

function _targets_subdir()
{
	SUBMAKE=$1
	TARGET=$2
	echo "targets_make: ${_SRCDIR_}/.build/${SUBPATH}/${SUBMAKE}/${MAKEFILE} ${TARGET}"
	make -C ${_SRCDIR_}/${SUBPATH}/${SUBMAKE} -f ${_SRCDIR_}/.build/${SUBPATH}/${SUBMAKE}/${MAKEFILE} $TARGET
	if [ $? -ne 0 ]; then
		echo "targets_make: ${_SRCDIR_}/.build/${SUBPATH}/${SUBMAKE}/${MAKEFILE} ${TARGET} - failed!"
		return 1
	fi
	return 0
}

function _targets_submake()
{
	SUBMAKE=$1
	TARGET=$2
	echo "targets_make: ${_SRCDIR_}/${SUBPATH}/${SUBMAKE} ${TARGET}"
	make -C ${_SRCDIR_}/${SUBPATH} -f ${_SRCDIR_}/${SUBPATH}/${SUBMAKE} $TARGET
	if [ $? -ne 0 ]; then
		echo "targets_make: ${_SRCDIR_}/${SUBPATH}/${SUBMAKE} ${TARGET} - failed!"
		return 1
	fi
	return 0
}

function targets_make()
{
#set -x
	adir=0
	amkf=0
	TARGET=$1
#	echo "TARGET: "$TARGET
#	env | grep -E "SUBPATH|SUBMAKES|_SRCDIR_|_BUILDIR_|_OBJDIR_" || true
	if [ -n "${SUBMAKES}" ]; then
		unset pids
		set +em
		for SUBMAKE in $SUBMAKES; do
			if [ -d "${_SRCDIR_}/${SUBPATH}/${SUBMAKE}" ]; then
				if [ $amkf -ne 0 ]; then
#					echo "PIDS:"$pids
					_wait_for_mejks $pids
					unset pids
				fi
				_targets_subdir $SUBMAKE $TARGET &
				pids="${pids} "$!
				adir=1
				amkf=0
			else
				if [ $adir -ne 0 ]; then
#					echo "PIDS:"$pids
					_wait_for_mejks $pids
					unset pids
				fi
				_targets_submake $SUBMAKE $TARGET &
				pids="${pids} "$!
				adir=0
				amkf=1
			fi
		done
#:		echo "PIDS:"$pids
		_wait_for_mejks $pids
		unset pids
		set -em
	else
		echo "targets_make: SUBMAKES variable empty!"
		return 1
	fi
}

$@
exit $?


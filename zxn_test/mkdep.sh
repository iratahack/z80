#!/bin/bash
#
# Script to generate dependancy files for make
#

if [ $# -ne 1 ]; then
	echo "Usage: $0 <source file>" >&2
	exit 1
fi

if [ ! -e $1 ]; then
	echo "$1: file does not exist." >&2
	exit 1
fi

file=$1
INCS=$(grep -iE "^\s*(include|binary)\s*\".*\"" $file | sed 's/\"//g' | awk '{print $2}')
echo "${file/.*/.o} ${file/.*/.d}: $file ${INCS//$'\n'/ }"

exit 0

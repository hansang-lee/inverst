#!/bin/bash

BASE_DIR="$(dirname "$(dirname "$(realpath "$0")")")"

exists() {
	if [ -e $1 ]; then
		return 0 # exist
	else
		return 1 # not exist
	fi
}

format() {
	if exists $1; then
		# run clang-format only if the passed path is valid
		find $1 \
			-iname *.h \
			-o -iname *.hpp \
			-o -iname *.cpp \
			-o -iname *.c \
			| xargs clang-format -i
	fi
}

if [ $# -gt 0 ]; then
	for path in "$@"; do
		echo "start format at $path"
		format $path
	done
else
	# if no specific path is passed, the entire path will be target to format
	format ${BASE_DIR}
fi

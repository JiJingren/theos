#!/usr/bin/env bash
# fakeroot.sh — shim for Windows.
#
# There is no privileged user here, so the wrapper itself does nothing; it still
# has to run the command it is handed. dm.pl fakes root ownership on its own.
#
# Accepted (and ignored) flags:
#   -p <path>  persistence file (no-op)
#   -c         start daemon (no-op)
#   -r         required mode (no-op)
#
# Everything else is executed as given.

while getopts ":p:rc" opt; do
	case $opt in
		p|c|r) ;;
		\?) break ;;
	esac
done
shift $((OPTIND - 1))

[ $# -eq 0 ] && exit 0

exec "$@"

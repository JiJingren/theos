#!/usr/bin/env bash
# fakeroot.sh — no-op on Windows.
#
# Packagers like dm.pl fake root ownership themselves, and there is no concept of
# a privileged user here. All flags (-p, -c, -r) are accepted and ignored.
exit 0

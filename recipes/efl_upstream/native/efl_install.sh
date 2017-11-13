#!/bin/bash
set -e

PROC_COUNT=$(grep -c ^processor /proc/cpuinfo)
PREFIX="$PWD/native/efl_upstream"

cd ./sources/efl_upstream/efl

./autogen.sh \
--prefix="$PREFIX" \
--disable-doc \
--with-systemdunitdir='$PREFIX/systemd_services'

make clean
make -j "$PROC_COUNT"
make install -j "$PROC_COUNT"

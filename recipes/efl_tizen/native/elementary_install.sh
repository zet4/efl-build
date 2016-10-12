#!/bin/bash
set -e

PROC_COUNT=$(grep -c ^processor /proc/cpuinfo)
PREFIX="$PWD/native/efl_tizen"

cd ./sources/efl_tizen/elementary

export CXXFLAGS="-std=gnu++11 -g -O2"
export CFLAGS="-g -O2"
export LDFLAGS=""
export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"

./autogen.sh \
--prefix="$PREFIX"

make clean
make -j "$PROC_COUNT"
make install -j "$PROC_COUNT"

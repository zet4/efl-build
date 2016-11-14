#!/bin/bash
set -e

PROC_COUNT=$(grep -c ^processor /proc/cpuinfo)
PREFIX="$PWD/native/efl_tizen"
cd ./sources/efl_tizen/efl

./autogen.sh --prefix="$PREFIX"

make clean
make -j "$PROC_COUNT"
make install -j "$PROC_COUNT"

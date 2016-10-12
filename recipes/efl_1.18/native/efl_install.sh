#!/bin/bash
set -e

PROC_COUNT=$(grep -c ^processor /proc/cpuinfo)
PREFIX="$PWD/native/efl_1.18"

cd ./sources/efl_1.18/efl

./autogen.sh --prefix="$PREFIX"

make clean
make -j "$PROC_COUNT"
make install -j "$PROC_COUNT"

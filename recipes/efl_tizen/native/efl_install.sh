#!/bin/bash
set -e

PROC_COUNT=$(grep -c ^processor /proc/cpuinfo)
PREFIX="$PWD/native/efl_tizen"
cd ./sources/efl_tizen/efl

#Tizen efl is somehow broken without specific flags combination so we should change one line is sources for native build
cp src/lib/edje/edje_calc.c src/lib/edje/edje_calc.c.bak
sed -i '5558s/.*/ }/' src/lib/edje/edje_calc.c

./autogen.sh --prefix="$PREFIX"

make clean
make -j "$PROC_COUNT"
make install -j "$PROC_COUNT"

#restoring sources
cp src/lib/edje/edje_calc.c.bak src/lib/edje/edje_calc.c
rm src/lib/edje/edje_calc.c.bak

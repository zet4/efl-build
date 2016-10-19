#!/bin/bash
set -e

PROC_COUNT=$(grep -c ^processor /proc/cpuinfo)
native=$PWD/native/efl_upstream/bin

BITS=64
LIBS="lib64"
HOST="x86_64-w64-mingw32"

cd ./sources/efl_upstream/eflete

export CXXFLAGS="-std=gnu++11 -fno-exceptions"
export CFLAGS="-I/opt/windows_$BITS/include/ -g -O2"
export LDFLAGS="-L/opt/windows_$BITS/$LIBS/"
export PKG_CONFIG_LIBDIR="/opt/windows_$BITS/$LIBS/pkgconfig"
export PKG_CONFIG_PATH="/opt/windows_$BITS/lib/pkgconfig"

./autogen.sh \
--prefix=/opt/windows_$BITS \
--host=$HOST \
--disable-audio \
--with-eolian-gen="$native/eolian_gen" \
--with-edje-cc="$native/edje_cc" \
--with-eet-eet="$native/eet" \
--with-elm-prefs-cc="$native/elm_prefs_cc" \
--with-elementary-codegen="$native/elementary_codegen"

make clean
make -j "$PROC_COUNT"
make install -j "$PROC_COUNT"

#!/bin/bash
set -e

PROC_COUNT=$(grep -c ^processor /proc/cpuinfo)
native=$PWD/native/efl_1.18/bin

BITS=32
LIBS="lib"
HOST="i686-w64-mingw32"

cd ./sources/efl_1.18/eflete

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
make -j $PROC_COUNT
make install -j $PROC_COUNT

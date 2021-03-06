#!/bin/bash
set -e

PROC_COUNT=$(grep -c ^processor /proc/cpuinfo)
# elementary build fails if it runs in parallel
native=$PWD/native/efl_tizen/bin
ln -fs $native/eolian_gen $native/eolian_gen.exe

BITS=32
LIBS="lib"
HOST="i686-w64-mingw32"

cd ./sources/efl_tizen/elementary

export CXXFLAGS="-std=gnu++11 -fno-exceptions"
export CFLAGS="-I/opt/windows_$BITS/include/ -g -O2"
export LDFLAGS="-L/opt/windows_$BITS/$LIBS/"
export PKG_CONFIG_LIBDIR="/opt/windows_$BITS/$LIBS/pkgconfig"
export PKG_CONFIG_PATH="/opt/windows_$BITS/lib/pkgconfig"

./autogen.sh \
--prefix=/opt/windows_$BITS \
--host=$HOST \
--with-tests=none \
--disable-cxx-bindings \
--disable-static \
--disable-nls \
--disable-doc \
--with-eolian-gen="$native/eolian_gen" \
--with-edje-cc="$native/edje_cc" \
--with-eet-eet="$native/eet" \
--with-eolian-cxx="$native/eolian_cxx" \
--with-elm-prefs-cc="$native/elm_prefs_cc" \
--with-elementary-codegen="$native/elementary_codegen"

make clean
make -j "$PROC_COUNT"
make install -j "$PROC_COUNT"

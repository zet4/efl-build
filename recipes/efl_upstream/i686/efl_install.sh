#!/bin/bash
set -e

PROC_COUNT=$(grep -c ^processor /proc/cpuinfo)
bash "$PWD/recipes/get_deps.sh" "$PWD/recipes/efl_upstream/i686/deps.list" i686
rm -rf "$PWD/cross/i686/efl_upstream"
mkdir --parents "$PWD/cross/i686/efl_upstream"
bash "$PWD/recipes/link_deps_list.sh" "$PWD/recipes/efl_upstream/i686/deps.list" "$PWD/packages/i686" "$PWD/cross/i686/efl_upstream"

echo "Linking $PWD/opt/windows_32"
mkdir --parents "$PWD/opt"
if [ -L "$PWD/opt/windows_32" ]
then
  rm "$PWD/opt/windows_32"
fi
ln -s "$PWD/cross/i686/efl_upstream" "$PWD/opt/windows_32"
ln -s "$PWD/recipes/efl_upstream/i686/pthread.h" "$PWD/opt/windows_32/include/pthread.h"

native=$PWD/native/efl_upstream/bin

BITS=32
LIBS="lib"
HOST="i686-w64-mingw32"

cd ./sources/efl_upstream/efl

export CXXFLAGS="-I/opt/windows_$BITS/include/ -std=gnu++11 -fno-exceptions"
export CFLAGS="-I/opt/windows_$BITS/include/ -g -O2"
export LDFLAGS="-L/opt/windows_$BITS/$LIBS/ -lws2_32 -llua -llibintl"
export PKG_CONFIG_LIBDIR="/opt/windows_$BITS/$LIBS/pkgconfig"
export PKG_CONFIG_PATH=""

./autogen.sh \
--prefix=/opt/windows_$BITS \
--host=$HOST \
--disable-pulseaudio \
--disable-physics \
--disable-gstreamer \
--disable-gstreamer1 \
--enable-lua-old \
--with-crypto=none \
--with-glib=no \
--with-tests=none \
--disable-libmount \
--disable-cxx-bindings \
--disable-image-loader-jp2k \
--disable-static \
--with-eolian-gen="$native/eolian_gen" \
--with-edje-cc="$native/edje_cc" \
--with-eet-eet="$native/eet" \
--with-elm-prefs-cc="$native/elm_prefs_cc" \
--with-elementary-codegen="$native/elementary_codegen"

make clean
make -j "$PROC_COUNT"
make install -j "$PROC_COUNT"

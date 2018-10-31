#!/bin/bash
set -e

PROC_COUNT=$(grep -c ^processor /proc/cpuinfo)
bash "$PWD/recipes/get_deps.sh" "$PWD/recipes/efl_upstream/x86_64/deps.list" x86_64
rm -rf "$PWD/cross/x86_64/efl_upstream"
mkdir --parents "$PWD/cross/x86_64/efl_upstream"
bash "$PWD/recipes/link_deps_list.sh" "$PWD/recipes/efl_upstream/x86_64/deps.list" "$PWD/packages/x86_64" "$PWD/cross/x86_64/efl_upstream"

echo "Linking $PWD/opt/windows_64"
mkdir --parents "$PWD/opt"
if [ -L "$PWD/opt/windows_64" ]
then
  rm "$PWD/opt/windows_64"
fi
ln -s "$PWD/cross/x86_64/efl_upstream" "$PWD/opt/windows_64"
#ln -s "$PWD/recipes/efl_upstream/x86_64/pthread.h" "$PWD/opt/windows_64/include/pthread.h"

native=$PWD/native/efl_upstream/bin

BITS=64
LIBS="lib64"
HOST="x86_64-w64-mingw32"

cd ./sources/efl_upstream/efl

export CXXFLAGS="-I/opt/windows_$BITS/include/ -std=gnu++11 -fno-exceptions -DECORE_WIN32_WIP_POZEFLKSD"
export CFLAGS="-I/opt/windows_$BITS/include/ -pipe -O2 -W -Wall -Wextra -g -ggdb3 -mtune=core2"
export LDFLAGS="-L/opt/windows_$BITS/$LIBS/ -lws2_32 -llua -llibintl"
export PKG_CONFIG_LIBDIR="/opt/windows_$BITS/$LIBS/pkgconfig"
export PKG_CONFIG_PATH=""
export CC="$HOST-gcc"

./autogen.sh \
--prefix=/opt/windows_$BITS \
--host=$HOST \
--with-windows-version=win7 \
--disable-pulseaudio \
--disable-physics \
--disable-gstreamer \
--disable-gstreamer1 \
--disable-avahi \
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

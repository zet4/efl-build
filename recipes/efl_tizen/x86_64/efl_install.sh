#!/bin/bash
set -e

PROC_COUNT=$(grep -c ^processor /proc/cpuinfo)
bash "$PWD/recipes/get_deps.sh" "$PWD/recipes/efl_tizen/x86_64/deps.list" x86_64
rm -rf "$PWD/cross/x86_64/efl_tizen"
mkdir --parents "$PWD/cross/x86_64/efl_tizen"
bash "$PWD/recipes/link_deps_list.sh" "$PWD/recipes/efl_tizen/x86_64/deps.list" "$PWD/packages/x86_64" "$PWD/cross/x86_64/efl_tizen"

echo "Linking $PWD/opt/windows_64"
if [ -L "$PWD/opt/windows_64" ]
then
  rm "$PWD/opt/windows_64"
fi
ln -s "$PWD/cross/x86_64/efl_tizen" "$PWD/opt/windows_64"

native=$PWD/native/efl_tizen/bin

BITS=64
LIBS="lib64"
HOST="x86_64-w64-mingw32"

cd ./sources/efl_tizen/efl

export CXXFLAGS="-std=gnu++11 -fno-exceptions"
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
--with-elementary-codegen="$native/elementary_codegen" \
--enable-i-really-know-what-i-am-doing-and-that-this-will-probably-break-things-and-i-will-fix-them-myself-and-send-patches-aba

make clean
make -j $PROC_COUNT
make install -j $PROC_COUNT

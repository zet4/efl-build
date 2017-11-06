#!/bin/bash
set -e

PROC_COUNT=$(grep -c ^processor /proc/cpuinfo)
PREFIX="$PWD/native/efl_tizen"
cd ./sources/efl_tizen/efl

./autogen.sh --prefix="$PREFIX"  --disable-xim --disable-scim --disable-wayland-text-input --disable-gesture --with-tests=none --disable-tslib \
--disable-physics --disable-gstreamer1 --with-opengl=es --enable-lua-old --disable-libmount --disable-cxx-bindings --disable-static --disable-fribidi \
--enable-i-really-know-what-i-am-doing-and-that-this-will-probably-break-things-and-i-will-fix-them-myself-and-send-patches-aba

make clean
make -j "$PROC_COUNT"
make install -j "$PROC_COUNT"

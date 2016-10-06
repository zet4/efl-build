set -e

if [ "$#" -ne 0 ]; then
  if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    exit 1
  fi
  if [[ $1 != 64 ]] && [[ $1 != 32 ]]; then
    echo "Illegal argument. Expected 32 or 64"
    exit 1
  fi
  BITS=$1
else
  BITS=64
fi

if [[ $BITS == 64 ]]; then
  LIBS="lib64"
  HOST="x86_64-w64-mingw32"
else
  LIBS="lib"
  HOST="i686-w64-mingw32"
fi

cd efl
export CXXFLAGS="-std=gnu++11 -fno-exceptions"
export CFLAGS="-I/opt/windows_$BITS/include/ -g -O2"
export LDFLAGS="-L/opt/windows_$BITS/$LIBS/ -lws2_32 -llua -llibintl"
export PKG_CONFIG_LIBDIR="/opt/windows_$BITS/$LIBS/pkgconfig"
#./configure \
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
		--with-eolian-gen=`which eolian_gen` \
		--with-edje-cc=`which edje_cc` \
		--with-eet-eet=`which eet` \
		--with-elm-prefs-cc=`which elm_prefs_cc` \
		--with-elementary-codegen=`which elementary_codegen`
make clean
make
make install

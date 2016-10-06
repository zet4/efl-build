set -e
cd efl
export CXXFLAGS="-std=gnu++11 -fno-exceptions"
export CFLAGS="-I/opt/windows_64/include/ -g -O2"
export LDFLAGS="-L/opt/windows_64/lib64/ -lws2_32 -llua -llibintl"
export PKG_CONFIG_LIBDIR="/opt/windows_64/lib64/pkgconfig"
#./configure \
./autogen.sh \
		--prefix=/opt/windows_64 \
		--host=x86_64-w64-mingw32 \
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

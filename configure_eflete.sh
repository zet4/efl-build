set -e
cd eflete
export CXXFLAGS="-std=gnu++11 -fno-exceptions"
export CFLAGS="-I/opt/windows_64/include/ -g -O2"
export LDFLAGS="-L/opt/windows_64/lib64/ -lws2_32 -llua"
export PKG_CONFIG_LIBDIR="/opt/windows_64/lib64/pkgconfig"
export PKG_CONFIG_PATH="/opt/windows_64/lib/pkgconfig"
./autogen.sh \
		--prefix=/opt/windows_64 \
		--host=x86_64-w64-mingw32 \
		--disable-budio \
		--disable-nls \
		--with-eolian-gen=`which eolian_gen` \
		--with-edje-cc=`which edje_cc` \
		--with-eet-eet=`which eet` \
		--with-elm-prefs-cc=`which elm_prefs_cc` \
		--with-elementary-codegen=`which elementary_codegen`
make clean
make
make install

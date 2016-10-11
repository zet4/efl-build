#!/bin/bash
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

LIST="env_config/win_builds_$BITS.list"
BASE_URL="http://win-builds.org/1.5.0/packages/windows_$BITS/"
BASE_PATH="/opt/windows_$BITS"

if [ -L $BASE_PATH ] ;
then
  echo "Removing old link $BASE_PATH"
  sudo rm $BASE_PATH
fi
echo "Creating new link $BASE_PATH -> $PWD$BASE_PATH"
sudo ln -s "$PWD$BASE_PATH" /opt/
echo ""

echo "Downloading packages into ./download/"
mkdir -p download
while read pkg; do
  if [[ ! ${pkg:0:1} == "#" ]] ;
  then
    if [ ! -f "download/$pkg" ]; then
      wget "$BASE_URL$pkg" -P download -q
    fi
    echo "[+] $pkg"
  fi
done < $LIST
if [ $BITS -eq 64 ]
then
  if [ ! -f "download/mingw-w64-x86_64-dlfcn-1.0.0-2-any.pkg.tar.xz" ]
  then
    wget "http://downloads.sourceforge.net/project/msys2/REPOS/MINGW/x86_64/mingw-w64-x86_64-dlfcn-1.0.0-2-any.pkg.tar.xz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fmsys2%2Ffiles%2FREPOS%2FMINGW%2Fx86_64%2F&ts=1476175877&use_mirror=heanet" -q -O download/mingw-w64-x86_64-dlfcn-1.0.0-2-any.pkg.tar.xz
  fi
  echo "[+] mingw-w64-x86_64-dlfcn-1.0.0-2-any.pkg.tar.xz"
else
  if [ ! -f "download/mingw-w64-i686-dlfcn-1.0.0-2-any.pkg.tar.xz" ]
  then
    wget "http://downloads.sourceforge.net/project/msys2/REPOS/MINGW/i686/mingw-w64-i686-dlfcn-1.0.0-2-any.pkg.tar.xz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fmsys2%2Ffiles%2FREPOS%2FMINGW%2Fi686%2F&ts=1476175952&use_mirror=heanet" -q -O download/mingw-w64-i686-dlfcn-1.0.0-2-any.pkg.tar.xz
  fi
  echo "[+] mingw-w64-i686-dlfcn-1.0.0-2-any.pkg.tar.xz"
fi
echo ""

echo "Unpacking packages into ./opt/"
rm -rf opt
mkdir -p opt
while read pkg; do
if [[ ! ${pkg:0:1} == "#" ]] ;
then
  tar -xf "download/$pkg" -C opt
  echo "[+] $pkg"
fi
done < $LIST
if [ $BITS -eq 64 ]
then
  tar -C opt/windows_64 -xf download/mingw-w64-x86_64-dlfcn-1.0.0-2-any.pkg.tar.xz mingw64 --strip-components 1
  echo "[+] mingw-w64-x86_64-dlfcn-1.0.0-2-any.pkg.tar.xz"
else
  tar -C opt/windows_32 -xf download/mingw-w64-i686-dlfcn-1.0.0-2-any.pkg.tar.xz mingw32 --strip-components 1
  echo "[+] mingw-w64-i686-dlfcn-1.0.0-2-any.pkg.tar.xz"
fi
echo ""

echo "Setup finished"

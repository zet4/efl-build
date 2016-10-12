#!/bin/bash
set -e

DEFAULT_ARCH=x86_64

if (($# < 1)) || (($# > 2))
then
  (>&2 echo "Usage: $0 DEPS.LIST [ARCH]")
  exit 1
fi

LIST=${1}
ARCH=${2-$DEFAULT_ARCH}

if [ ! -r "$LIST" ]
then
  (>&2 echo "Can't read file \"$LIST\"")
  exit 2
fi

if [[ "$ARCH" == "x86_64" ]]
then
  BASE_URL="http://win-builds.org/1.5.0/packages/windows_64/"
  DEFAULT_TAR_ARGS="windows_64 --strip-components 1"
elif [[  "$ARCH" == "i686" ]]
then
  BASE_URL="http://win-builds.org/1.5.0/packages/windows_32/"
  DEFAULT_TAR_ARGS="windows_32 --strip-components 1"
else
  (>&2 echo "Error: unknown arch \"$ARCH\". Expecting x86_64 or i686")
  exit 3
fi

PKG_DIR="${EFL_CROSS_PKG_DIR-$PWD/packages}/$ARCH"
DWN_DIR="${EFL_CROSS_PKG_DIR-$PWD/packages}/downloads"
mkdir --parents "$PKG_DIR"
mkdir --parents "$DWN_DIR"

# LIST file format: PKG_NAME;[URL];[TAR_ARGS]
# if no URL is given file is downloaded from $BASE_URL/$PKG_NAME
# if URL is given then file is downloaded from $URL without adding $PKG_NAME
# TAR_ARGS will be passed to tar
IFS=';'
echo "Downloading packages into $DWN_DIR"
while read pkg; do
  if [[ ! ${pkg:0:1} == "#" ]] ;
  then
    pkg=(${pkg})
    if [ ! -f "$DWN_DIR/${pkg[0]}" ]
    then
      wget "${pkg[1]-$BASE_URL/${pkg[0]}}" -O "$DWN_DIR/${pkg[0]}" -q
    fi
    echo "[+] ${pkg[0]}"
  fi
done < "$LIST"

echo "Unpacking packages into $PKG_DIR"
while read pkg; do
if [[ ! ${pkg:0:1} == "#" ]] ;
then
  IFS=';'
  pkg=(${pkg})
  if [ ! -e "$PKG_DIR/${pkg[0]}" ]
  then
    mkdir "$PKG_DIR/${pkg[0]}"
    IFS=' '
    tar -xf "$DWN_DIR/${pkg[0]}" -C "$PKG_DIR/${pkg[0]}" ${pkg[2]-$DEFAULT_TAR_ARGS}
    echo "[+] ${pkg[0]}"
  fi
fi
done < "$LIST"

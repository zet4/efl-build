#!/bin/bash
set -e

if (($# < 3)) || (($# > 3))
then
  (>&2 echo "Usage: $0 DEPS.LIST PKG_DIR DEST")
  exit 1
fi

LIST=$1
PKG_DIR=$2
DEST_DIR=$3
SRC_DIR=$(cd "$(dirname "$0")"; pwd)

if [ ! -r "$LIST" ]
then
  (>&2 echo "Can't read file \"$LIST\"")
  exit 2
fi

# LIST file format: PKG_NAME;[URL];[TAR_ARGS]
# if no URL is given file is downloaded from $BASE_URL/$PKG_NAME
# if URL is given then file is downloaded from $URL without adding $PKG_NAME
# TAR_ARGS will be passed to tar
echo "Linking packages to $DEST_DIR"
while read pkg; do
  if [[ ! ${pkg:0:1} == "#" ]] ;
  then
    pkg=(${pkg//;/ })
    bash "$SRC_DIR/link_folders_recursively.sh" "$PKG_DIR/${pkg[0]}" "$DEST_DIR"
    echo "[+] ${pkg[0]}"
  fi
done < "$LIST"

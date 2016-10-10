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

if [ -e $BASE_PATH ] && [ -L $BASE_PATH ] ;
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
echo ""

echo "Setup finished"

#!/bin/bash
set -e

if [ -L "/opt/windows_64" ]
then
  rm "/opt/windows_64"
fi
ln -s "$PWD/opt/windows_64" "/opt/windows_64"

if [ -L "/opt/windows_32" ]
then
  rm "/opt/windows_32"
fi
ln -s "$PWD/opt/windows_32" "/opt/windows_32"

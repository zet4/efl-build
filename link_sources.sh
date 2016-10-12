#!/bin/bash
set -e

link() {
  efl=$1
  package=$2
  mkdir --parents "./sources/$efl"

  if [ ! -e ./sources/$efl/$package ]
  then
    read -e -p "[$efl] $package sources path: " -i "/" SRC
    if [[ ! "${SRC}" == "/" ]]
    then
      if [ -e "$SRC" ]
      then
        SRC=$(cd "$SRC"; pwd)
        ln -s "$SRC" "./sources/$efl/$package"
      else
        echo "Path doesn't exist: \"$SRC\""
        echo "skipping"
      fi
    else
      echo "skipping"
    fi
  fi
}

link efl_1.18 efl
link efl_1.18 eflete
link efl_tizen efl
link efl_tizen elementary
link efl_tizen eflete

#!/bin/bash
set -e

link() {
  efl=$1
  package=$2
  mkdir --parents "./sources/$efl"

  case "$efl" in
    efl_upstream) root="https://git.enlightenment.org"
  esac

  case "$package" in
    efl )      git -c http.sslVerify=false clone "$root/core/efl.git" "./sources/$efl/$package" ;;
    eflete )   git -c http.sslVerify=false clone "$root/tools/eflete.git" "./sources/$efl/$package" ;;
  esac
}

link efl_upstream efl
link efl_upstream eflete

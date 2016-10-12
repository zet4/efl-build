#!/bin/bash
set -e

if (($# < 3)) || (($# > 3))
then
  (>&2 echo "Usage: $0 EFL_VERSION ARCH PACKAGE")
  exit 1
fi

if [ ! -e "./recipes/$1" ]; then (>&2 echo "no recipe for $1"); exit 1; fi
if [ ! -e "./recipes/$1/$2" ]; then (>&2 echo "no recipe for $1/$2"); exit 2; fi
if [ ! -e "./recipes/$1/$2/${3}_install.sh" ]; then (>&2 echo "no recipe for $1/$2/$3"); exit 3; fi

bash "./recipes/$1/$2/${3}_install.sh"

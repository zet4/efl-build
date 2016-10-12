#!/bin/bash
set -e

if (($# < 2)) || (($# > 2))
then
  (>&2 echo "Usage: $0 SOURCE DEST")
  exit 1
fi

SOURCE=$(cd "$1"; pwd)
DEST=$(cd "$2"; pwd)

#copy directory tree without files
rsync -a -f"+ */" -f"- *" "$SOURCE/" "$DEST/"

#create links to all files
while read -r file
do
    ln -s "$SOURCE/$file" "$DEST/$file"
done < <(cd "$SOURCE"; find . -type f)

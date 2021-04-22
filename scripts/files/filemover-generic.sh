#!/bin/bash

SRC="<src_goes_here>"
DEST_P="<dest_goes_here>"
MAP=$(cat << EOF
file_in_src -> subdir_in_dest
EOF
)

while read line; do
  CARD=$(echo $line | awk '{ print $1 }')
  DEST=$(echo $line | awk '{ print $3 }')
  echo "$DEST_P/$DEST:"
  while read item; do
    echo "- $item"
  done < <(ls "$SRC" | grep $CARD)
  read -p "Move these files? (y/n) " RESPONSE 0</dev/tty
  if [[ "y|Y" =~ $RESPONSE ]]; then
    while read item; do
      mv "$SRC/$item" "$DEST_P/$DEST"
    done < <(ls "$SRC" | grep $CARD)
  fi
done < <(echo "$MAP")

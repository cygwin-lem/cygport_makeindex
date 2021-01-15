#!/bin/bash

ARCHS=( $(uname -m) noarch )

echo "Install local packages..."

get_list0() {
  for ARCH in "${ARCHS[@]}"; do
    find . -maxdepth 1 -type d -name "*.${ARCH}" -print0
  done \
  | \
  while read -r -d '' P; do
    find "$P/dist" \
      -name \*.xz \
      -a -not -name "*src*" \
      -a -not -name "*debuginfo*" \
      -print0
  done
}

get_list0 \
| \
while read -r -d '' F; do
  echo $F
done

echo "Start in 2 seconds..."
sleep 2

get_list0 \
| \
while read -r -d '' F; do
  tar -C / -Jxvf "$F"
done

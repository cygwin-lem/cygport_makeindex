#!/bin/bash

remove_test () {
  : \
  && cp "$1" "$1.tmp" \
  && grep -ve '^test:$' < "$1.tmp" > "$1" \
  && rm -f "$1.tmp" \
  && :
}


find -name '*.hint' -type f -print0 \
| while read -rd '' F; do remove_test "$F"; done



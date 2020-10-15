#!/bin/bash

declare -A ARCH2M

ARCH2M=(
  ["x86_64"]="x86_64"
  ["x86"]="i686"
  ["noarch"]="noarch"
)

list2html () {
  echo "<html><body><ul>"
  perl -ne 'chop; print "<li><a href=\"$_\">$_</a></li>\n";'
  echo "</ul></body></html>"
}

makelist () {
  local D
  for M in "${ARCH2M[@]}"; do
    D=$(find *."${M}" -mindepth 1 -maxdepth 1 -name dist -type d 2>/dev/null)
    if [ -n "$D" ]; then
      find $D -type f
    fi
  done
}

gitadd () {
  local D
  for M in "${ARCH2M[@]}"; do
    D=$(find *."${M}" -mindepth 1 -maxdepth 1 -name dist -type d 2>/dev/null)
    if [ -n "$D" ]; then
      git add $D
    fi
  done
}

gitadd

git rm -f index.html 2> /dev/null

( echo "Packages and hints"; echo ""; git diff --name-only HEAD ) > msg

makelist | list2html > index.html
git add index.html

git commit -F msg

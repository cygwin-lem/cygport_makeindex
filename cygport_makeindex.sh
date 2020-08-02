#!/bin/bash

declare -A ARCH2M

ARCH2M=(
  ["x86_64"]="x86_64"
  ["x86"]="i686"
)

list2html () {
  echo "<html><body><ul>"
  perl -ne 'chop; print "<li><a href=\"$_\">$_</a></li>\n";'
  echo "</ul></body></html>"
}

makelist () {
  for M in "${ARCH2M[@]}"; do
    find $(find *."${M}" -mindepth 1 -maxdepth 1 -name dist) -type f
  done
}

for M in "${ARCH2M[@]}"; do
  git add $(find *."${M}" -mindepth 1 -maxdepth 1 -name dist -type d)
done

git rm -f index.html 2> /dev/null

( echo "Packages and hints"; echo ""; git diff --name-only HEAD ) > msg

makelist | list2html > index.html
git add index.html

git commit -F msg

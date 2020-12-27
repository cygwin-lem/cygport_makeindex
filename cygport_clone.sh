#!/bin/bash

CYGWIN_PACKAGES_ROOT_BROWSE="https://cygwin.com/git/?p=git/cygwin-packages"
CYGWIN_PACKAGES_ROOT_GIT="https://cygwin.com/git/cygwin-packages"

inform () {
  printf "*** Info: %s\n" "$*"
}
warn () {
  printf "*** Warning: %s\n" "$*"
}

error () {
  printf "*** Error: %s\n" "$*"
  exit 1
}

git_cygwin_packages_clone () {
  local NAME="$1"
  local REPO_CYGWIN="${CYGWIN_PACKAGES_ROOT_GIT}/${NAME}"
  local REPO_LOCAL="${NAME}-cygport"

  if [ -d "${REPO_LOCAL}" ]; then
    error "Already exists ${REPO_LOCAL}"
    return 1
  fi

  inform "Cloning ${REPO_CYGWIN}"

  mkdir -p "${REPO_LOCAL}"
  git -C "${REPO_LOCAL}" init
  git -C "${REPO_LOCAL}" remote add \
    cygwin "${REPO_CYGWIN}"
  git -C "${REPO_LOCAL}" remote add --no-tags\
    playground ssh://cygwin@cygwin.com/git/cygwin-packages/playground
  git -C "${REPO_LOCAL}" remote update
  git -C "${REPO_LOCAL}" checkout \
    -b master --track cygwin/master
}

for N in "$@"; do
  git_cygwin_packages_clone "${N}"
done



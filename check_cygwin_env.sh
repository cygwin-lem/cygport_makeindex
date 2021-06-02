#!/bin/sh
################################################################
# __check_cygwin_env ():
#   a function to extract the last
#   setting of a specified option in CYGWIN variable.
#
#   Usage: __check_cygwin_env option_name
#
#   cf. The Cygwin User's Guide: The CYGWIN environment variable [1].
#   [1]: https://cygwin.com/cygwin-ug-net/using-cygwinenv.html
#
__check_cygwin_env () {
  X_R=''
  X_C=`printf "%s" "$1" | sed -e 's/^no//'`        # Remove a prefix 'no'
  for X_OPT in ${CYGWIN}; do
    X_T="${X_OPT}"
    X_T=`printf "%s" "${X_T}" | sed -e 's/^no//'`  # Remove a prefix 'no'
    X_T=`printf "%s" "${X_T}" | sed -e 's/:.*$//'` # Remove optional parameters
    if [ x"${X_T}" = x"${X_C}" ]; then
      X_R="${X_OPT}"
    fi
  done
  printf "%s" "${X_R}"
}

################################################################
__check_cygwin_env "$@"

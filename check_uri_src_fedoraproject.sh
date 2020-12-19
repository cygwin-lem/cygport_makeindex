#!/bin/bash

# http://pkgs.fedoraproject.org/cgit/shared-mime-info.git/plain/0001-Remove-sub-classing-from-OO.o-mime-types.patch
# http://pkgs.fedoraproject.org/cgit/rpms/libkexif.git/plain/libkexif-0.2.5-qcombobox.patch
# https://src.fedoraproject.org/rpms/dbus/raw/f33/f/00-start-message-bus.sh

update_uri_src_fedoraproject_rpms() {
  local U="$1"
  local P="${U/\/*}"
  local B="${U#*/}"; B="${B#raw/}"; B="${B/\/*}"
  local F="${U#*/}"; F="${F#raw/*/f/}";

  local N="https://src.fedoraproject.org/rpms/${P}/raw/${B}/f/${F}"
  local C=34
  
  until printf "TRY: %s\n" "${N}" >&2 && curl -sfLI "${N}" > /dev/null; do
    (( C = C-1 ))
    if (( C < 20 )) ; then
      echo "Give up..." >&2
      return 1
    fi
    B="f${C}"
    N="https://src.fedoraproject.org/rpms/${P}/raw/${B}/f/${F}"
  done
  echo "OK" >&2

  printf "%s" "${N}"

}

update_uri_pkgs_fedoraproject() {
  local U="${1#rpms/}"
  local P="${U/\/*}"; P="${P%.git}"
  local B="master"
  local F="${U#*/}"; F="${F#*/}"
  update_uri_src_fedoraproject_rpms "${P}/raw/${B}/f/${F}"
}

check_uri_fedoraproject() {
  case "$1" in
   https://src.fedoraproject.org/rpms/* ) # Current
     update_uri_src_fedoraproject_rpms "${1#https://src.fedoraproject.org/rpms/}"
     ;;
   http://pkgs.fedoraproject.org/cgit/* ) # Old
     update_uri_pkgs_fedoraproject "${1#http://pkgs.fedoraproject.org/cgit/}"
     ;; 
   * ) # Unknown
     echo "Unknown pattern: $1" >&2
     exit 1;
     ;;
  esac
}

for URL in "$@"; do
  check_uri_fedoraproject "$1"; echo
done


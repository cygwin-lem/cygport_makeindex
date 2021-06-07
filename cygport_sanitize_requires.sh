#!/bin/bash

declare -A CHECK_LIST=(
  [lua54]="lua53 lua52 lua51"
  [lua53]="lua54 lua52 lua51"
  [lua52]="lua54 lua53 lua51"
  [lua51]="lua54 lua53 lua52"
)

sanitize_requires () {
  local FILE=${1}
  local BASE=${FILE##*/}; BASE=${BASE%%-*}
  local PKG=${FILE##*/}; PKG=${PKG%%-[0123456789]*}

  local LIST="${CHECK_LIST[${BASE}]}"
  [ -z "${LIST}" ] && return

  echo "${FILE}: Replacing ${LIST} by ${BASE}"

  local L
  local R
  local T
  local K

  : \
  && cp "${FILE}" "${FILE}.tmp" \
  && cat "${FILE}.tmp" | while IFS= read -r L; do
       if [ x"${L#requires: }" = x"${L}" ]; then
         printf "%s\n" "${L}"
       else
         L="${L#requires: }"
         printf "%s" "requires:"
         for K in ${L}; do
           for R in ${LIST}; do
             K="${K/#${R}-/${BASE}-}"
           done
           [ x"${PKG}" = x"${K}" ] && K=""
           [ -n "${K}" ] && printf "%s\n" "$K"
         done | sort -u | xargs -r printf " %s"
         printf "\n"
       fi
     done > "${FILE}" \
  && rm -f "${FILE}.tmp" \
  :
}


find -name '*.hint' -type f -print0 \
| while read -rd '' F; do sanitize_requires "$F"; done



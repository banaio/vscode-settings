#!/usr/bin/env bash
# Usage: gopls_build.sh
#
# Documentation: TODO.

set -euf \
  -o nounset \
  -o errexit \
  -o noclobber \
  -o pipefail
shopt -s \
  extglob \
  globstar \
  nullglob

function print_separators() {
  local sep_char="${1:-}"
  printf -- "${sep_char}%.0s" $(seq 1 $(($(tput cols) - ${#sep_char}))) $'\n'
}

DIR_CURRENT="$(pwd)"
DIR_CODE="${DIR_CURRENT}/code"
DIR_BUILDS="${DIR_CURRENT}/builds/$(date -u +'%Y_%m_%d-%k_%M_%S_%Z')"

function golps_update_repo() {
  if [[ ! -d "${DIR_CODE}" ]]; then
    mkdir -p -v "${DIR_CODE}"
  fi
  cd "${DIR_CODE}"

  if [[ ! -d "tools" ]]; then
    # gh repo clone git@github.com:banaio/tools.git
    git clone git@github.com:banaio/tools.git
  fi
  cd tools

  git fetch --all
  echo
  git log --graph -n2
  echo
  ls -t -lah
  echo
}
function golps_build() {
  cd "${DIR_CODE}"
  ls -C1
}

function gopls_all() {
  print_separators ">"
  golps_update_repo
  print_separators
  golps_build
  print_separators "<"
}

mkdir -vp "${DIR_CODE}"
cd "${DIR_CODE}"
echo
gopls_all

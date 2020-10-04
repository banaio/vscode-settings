#!/usr/bin/env bash
# Usage: gopls_build.sh
#
# Documentation: rebase master branch of tools into mine, then generate latest `gopls.exe` binary.

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
DIR_REPO="${DIR_CODE}/tools"

function golps_update_repo() {
  if [[ ! -d "${DIR_CODE}" ]]; then
    mkdir -p -v "${DIR_CODE}"
  fi
  cd "${DIR_CODE}"

  if [[ ! -d "${DIR_REPO}" ]]; then
    gh repo clone banaio/tools
    # gh repo clone git@github.com:banaio/tools.git
    # git clone git@github.com:banaio/tools.git
  fi
  cd tools

  git stash
  echo
  git remote --v
  echo
  git fetch --all
  echo
  git checkout master
  echo
  git rebase upstream/master
  echo
  git log --graph -n2
  echo
  # checkout previous branch
  git checkout -
  echo
  git stash pop || true
  # ls -t -lah
  echo
}
function golps_build() {
  if [[ ! -d "${DIR_REPO}" ]]; then
    printf '%b' "$(tput bold)" "$(tput setaf 1)" "ERROR: " "$(tput sgr0)" "repository directory ${DIR_REPO} does not exist" "\n"
    exit 1
  fi
  cd "${DIR_REPO}"
  go build -o gopls.exe ./gopls/main.go
  echo
  ls -lah -t
}

function gopls_all() {
  print_separators ">"
  golps_update_repo
  echo
  print_separators
  echo
  golps_build
  print_separators "<"
}

mkdir -vp "${DIR_CODE}"
cd "${DIR_CODE}"
gopls_all

#!/usr/bin/env bash
# Usage: `cd .vscode && ./snippets_backup.sh`
#
# Backups snippets to a new directory in the `snippets_backup directory`, e.g.,
# after a run these files will be present:#
#
# .vscode/snippets_backup/2020_09_26-19_23_47_UTC/golang.code-snippets
# .vscode/snippets_backup/2020_09_26-19_23_47_UTC/makefile.code-snippets
# .vscode/snippets_backup/2020_09_26-19_23_47_UTC/markdown.code-snippets
# .vscode/snippets_backup/2020_09_26-19_23_47_UTC/rustlang.code-snippets
# .vscode/snippets_backup/2020_09_26-19_23_47_UTC/shellscript.code-snippets

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
  printf -- '-%.0s' $(seq 1 $(($(tput cols) - 1))) $'\n'
}

DIR_VSCODE="$(pwd)"
DIR_BACKUP="${DIR_VSCODE}/snippets_backup/$(date -u +'%Y_%m_%d-%k_%M_%S_%Z')"

print_separators
mkdir -vp "${DIR_BACKUP}"
cd "${DIR_BACKUP}"
find "${DIR_VSCODE}" -mindepth 1 -maxdepth 1 \( -iname '*.code-snippets*' \) -exec cp -v -t "${DIR_BACKUP}" {} +
cd "${DIR_VSCODE}"
print_separators

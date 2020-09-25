#!/usr/bin/env bash
# Make shellcheck ignore this file, see https://github.com/koalaman/shellcheck/wiki/Ignore#ignoring-all-instances-in-a-file-044
# shellcheck disable=SC2059
set -euf \
  -o nounset \
  -o errexit \
  -o noclobber \
  -o pipefail

shopt -s \
  extglob \
  globstar \
  nullglob

source ./functions.sh

# https://stackoverflow.com/questions/23356779/how-can-i-store-the-find-command-results-as-an-array-in-bash/54561526
FOUND=(
  $(
    find .vscode/ -mindepth 1 -maxdepth 1 \
      \( -iname '*.code-snippets*' \) \
      -printf '%p\n'
  )
)
TOTAL=$(printf -- '%s\n' "${FOUND[@]}" | wc -l)
export FOUND
export TOTAL

print_separator

printf -- "${INDENT}%b" \
  "${GREEN}FOUND${RESET}=${FOUND[*]}" $'\n' \
  "${GREEN}TOTAL${RESET}=${TOTAL}" $'\n'

for SNIPPET_FILE in "${FOUND[@]}"; do
  print_separator
  printf "${GREEN}%s${RESET}=%s\n" 'SNIPPET_FILE' "${SNIPPET_FILE}"
  echo
  jq -r 'to_entries[] | .value | to_entries[] | ("name="+.key+", prefix="+(.value.prefix|tostring))' "${SNIPPET_FILE}"
done

# ls -1 .vscode/*.code-snippets | xargs -n1 -I{} sh -c 'echo "snippet_file={}"; jq -r "to_entries[] | .value | to_entries[] | .key" {}'

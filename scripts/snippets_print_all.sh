#!/usr/bin/env bash
# Usage:
# $ ./scripts/snippets_print_all.sh
# $ ./scripts/snippets_print_all.sh | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | cat | wl-copy
set -euf \
  -o nounset \
  -o errexit \
  -o noclobber \
  -o pipefail
shopt -s \
  extglob \
  globstar \
  nullglob

source ./scripts/functions.sh

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
  jq -r "to_entries[] | (\"name='\" + .key + \"', prefix='\" +(.value.prefix|tostring) + \"'\" )" "${SNIPPET_FILE}"
  # jq -r 'to_entries[] | ("name="+.key+", prefix="+(.value.prefix|tostring))' "${SNIPPET_FILE}"
  # jq -r 'to_entries[] | ("name=\''"+.key+"\'', prefix=\''"+(.value.prefix|tostring)+"\''")' "${SNIPPET_FILE}"
done

print_separator

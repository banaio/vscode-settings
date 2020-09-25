#!/usr/bin/env bash
# Usage:
# ./docs/snippets_md_update.sh
#
# Updates `docs/SNIPPETS.md` with available snippets.

set -euf \
  -o nounset \
  -o errexit \
  -o errtrace \
  -o noclobber \
  -o pipefail \
  -o posix \
  -o functrace \
  -o notify

# set \
#   +o notify \
#   +o privileged

shopt -s \
  extglob \
  globstar \
  nullglob \
  failglob \
  gnu_errfmt \
  localvar_unset \
  dotglob \
  xpg_echo

function print_separators() {
  printf -- '-%.0s' $(seq 1 $(($(tput cols) - 1))) $'\n'
}

# 2020-09-26T22:43:43+00:00
SNIPPET_MD_UPDATE_DATE_TIME=$(date -Iseconds -u)
# If above fails use below version.
# # 2020-09-25T20:45:44+0000
# SNIPPET_MD_UPDATE_DATE_TIME=$(date -u +"%Y-%m-%dT%H:%M:%S%z")

# Snippets Files
# shellcheck disable=SC2016
SNIPPETS_FILES_HYPERLINKS=$(find .vscode -mindepth 1 -maxdepth 1 \( -iname '*.code-snippets*' \) -exec echo '* [`../{}`](../{}).' \;)
# shellcheck disable=SC2016
SNIPPETS_FILES_HYPERLINKS_ROOT=$(find .vscode -mindepth 1 -maxdepth 1 \( -iname '*.code-snippets*' \) -exec echo '* [`/{}`](/{}).' \;)
# find .vscode -mindepth 1 -maxdepth 1 \( -iname '*.code-snippets*' \) -printf '%p\n'

# shellcheck disable=SC2207
SNIPPET_FILES=(
  $(find .vscode -mindepth 1 -maxdepth 1 \( -iname '*.code-snippets*' \) -print)
)
# $(find .vscode -mindepth 1 -maxdepth 1 \( -iname '*.code-snippets*' \) -print)
# SNIPPET_FILES=$(find .vscode -mindepth 1 -maxdepth 1 \( -iname '*.code-snippets*' \) -printf '%p\n')
# SNIPPET_FILES=$(ls -1 .vscode/* | sort | grep '.code-snippets')

# Snippets Details
SNIPPET_DETAILS=$(
  for SNIPPET_FILE in "${SNIPPET_FILES[@]}"; do
    echo "### \`${SNIPPET_FILE}\`"
    echo
    jq -r "to_entries[] | (\"* name=\`\" + .key + \"\`, prefix=\`\" +(.value.prefix|tostring) + \"\`.\" )" "${SNIPPET_FILE}"
    echo
  done
)
# SNIPPET_DETAILS=$(scripts/snippets_print_all.sh)

echo "\
# \`SNIPPETS\`

\`docs/SNIPPETS.md\` updated on \`${SNIPPET_MD_UPDATE_DATE_TIME}\`.

## Snippets Links

${SNIPPETS_FILES_HYPERLINKS}

or failing that, try:

${SNIPPETS_FILES_HYPERLINKS_ROOT}

## Snippet Files

\`\`\`sh
$ ls -1 .vscode/* | sort | grep '.code-snippets'
$(printf -- '%b\n' "${SNIPPET_FILES[@]}")
\`\`\`

## Snippets Details

${SNIPPET_DETAILS}
" >|docs/SNIPPETS.md

print_separators
echo "\`docs/SNIPPETS.md\` updated on \`${SNIPPET_MD_UPDATE_DATE_TIME}\`"
print_separators

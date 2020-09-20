#!/usr/bin/env bash
set -euf \
  -o nounset \
  -o errexit \
  -o noclobber \
  -o pipefail

# https://stackoverflow.com/questions/9910966/how-to-get-shell-to-self-detect-using-zsh-or-bash
# https://stackoverflow.com/a/9911082/241993
# https://unix.stackexchange.com/questions/9501/how-to-test-what-shell-i-am-using-in-a-terminal
case "${SHELL}" in
*/zsh)
  # assume Zsh
  ;;
*/bash)
  # assume Bash
  shopt -s \
    extglob \
    globstar \
    nullglob
  ;;
*) ;;
  # assume something else
esac

source ./scripts/functions.sh

# https://stackoverflow.com/questions/23356779/how-can-i-store-the-find-command-results-as-an-array-in-bash/54561526
FOUND=(
  $(
    find ./scripts -mindepth 1 -maxdepth 1 \
      \( -iname '*install_*.sh*' \) \
      -a \
      -not \( -iname "*${SCRIPT_NAME}*" \) \
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

for TOOL in "${FOUND[@]}"; do
  print_separator
  printf "${INDENT}${GREEN}%s${RESET}=%s\n" 'TOOL' "${TOOL}"
  echo
done

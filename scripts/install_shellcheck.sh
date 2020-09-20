#!/usr/bin/env bash
# Installs:
# *
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

CMD="shellcheck"

print_separator_v3
printf -- "${INDENT}%b" \
  "${GREEN}CMD${RESET}=${CMD}" $'\n'

printf "%b" \
  "${RED_STRING}" \
  "TODO: shellcheck, shellcheck=$(command -v "${CMD}")" \
  $'\n'
exit 1

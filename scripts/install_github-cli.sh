#!/usr/bin/env bash
# Installs:
# * https://github.com/cli/cli
# * https://github.com/cli/cli/blob/trunk/docs/source.md
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

COMMAND="gh"
CLONE_PATH="${HOME}/dev/go"

print_separator_v3
printf -- "${INDENT}%b" \
  "COMMAND=${COMMAND}" $'\n' \
  "CLONE_PATH=${CLONE_PATH}" $'\n'

if [[ -x "$(command -v gh 2>/dev/null)" ]]; then
  echo "$(
    tput bold
    tput setaf 2
  )INFO:$(tput sgr0) FOUND - command=gh, path=$(command -v gh 2>/dev/null) - exiting ..."

  exit 0
else
  echo "$(
    tput bold
    tput setaf 1
  )ERROR:$(tput sgr0) NOT FOUND - command=gh - installing ..."
fi

exit 0

mkdir -v "${CLONE_PATH}"
cd "${CLONE_PATH}"
pwd
ls -lah

git clone git@github.com:cli/cli.git gh-cli
cd gh-cli
make
sudo mv ./bin/gh /usr/local/bin/
gh version
gh config set editor "code --wait --new-window"
gh config set git_protocol ssh
gh config set prompt enabled
gh auth login --web

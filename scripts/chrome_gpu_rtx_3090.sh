#!/usr/bin/env bash
# Usage: chrome_gpu_rtx_3090.sh
#
# Documentation: Wrapper to launch VSCode with GPU flags. See:
# * https://www.meshcloud.io/2019/07/17/gpu-acceleration-for-chromium-and-vscode/
set -euf \
  -o nounset \
  -o errexit \
  -o noclobber \
  -o pipefail
shopt -s \
  extglob \
  globstar \
  nullglob

UNAME_S="$(uname -s)"
BINARY_NAME="google-chrome"
BINARY_PATH=""

if [[ "${UNAME_S}" = "Linux" ]]; then
  set -euf \
    -o nounset \
    -o errexit \
    -o errtrace \
    -o noclobber \
    -o pipefail \
    -o posix \
    -o functrace \
    -o notify

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

  if [[ -x "$(command -v "${BINARY_NAME}" 2>/dev/null)" ]]; then
    BINARY_PATH="$(command -v "${BINARY_NAME}" 2>/dev/null)"
  else
    BINARY_PATH="/usr/bin/${BINARY_NAME}"
    printf '%b' "$(tput bold)" "$(tput setaf 3)" "WARN: " "$(tput sgr0)" "could not find ${BINARY_NAME} in path so using ${BINARY_PATH}" "\n"
  fi
elif [[ "${UNAME_S}" = "Darwin" ]]; then
  # set -euf \
  #   -o nounset \
  #   -o errexit \
  #   -o noclobber \
  #   -o pipefail
  # shopt -s \
  #   extglob \
  #   globstar \
  #   nullglob

  print_separators() {
    printf -- '-%.0s' $(seq 1 $(($(tput cols) - 1)))
    echo
  }

  printf '%b' "$(tput bold)" "$(tput setaf 1)" "ERROR: " "$(tput sgr0)" "unsupported platform" "\n"
  # if [[ -x "$(command -v code 2>/dev/null)" ]]; then
  #   BINARY_PATH="$(command -v code 2>/dev/null)"
  # else
  #   BINARY_PATH="/usr/local/bin/code"
  #   printf '%b' "$(tput bold)" "$(tput setaf 3)" "WARN: " "$(tput sgr0)" "could not find code in path so using ${BINARY_PATH}" "\n"
  # fi
else
  printf '%b' "$(tput bold)" "$(tput setaf 1)" "ERROR: " "$(tput sgr0)" "unsupported platform" "\n"
  exit 1
fi

print_separators
echo

echo 'Open this URL in a new tab to see GPU status'
printf '%b' "$(tput bold)" "$(tput setaf 2)" 'chrome://gpu' "$(tput sgr0)" "\n"
echo

# '--disable-gpu-driver-bug-workarounds'
ARGS_BINARY=(
  '--ignore-gpu-blacklist'
  '--enable-gpu-rasterization'
  '--enable-native-gpu-memory-buffer'
  '--enable-zero-copy'
  '--enable-oop-rasterization'
)
# ARGS_APP=(
#   '--new-window chrome://gpu'
# )
ARGS_ALL=$(printf '%b' "${ARGS_BINARY[*]}")
# ARGS_ALL=$(printf '%b' "${ARGS_BINARY[*]}" ' ' "${ARGS_APP[*]}")

# shellcheck disable=SC2086
set -- ${ARGS_ALL} "${@:1}"

############## shellcheck disable=SC2068,SC2116,SC2046
# shellcheck disable=SC2116
printf '%b' \
  "launching:" "\n" \
  "$(tput bold)" "$(tput setaf 2)" "${BINARY_PATH}" ' ' "$(echo "$@")" "$(tput sgr0)" \
  "\n"
echo

print_separators
echo

# export __NV_PRIME_RENDER_OFFLOAD_PROVIDER="NVIDIA-G0"
# export __GLX_VENDOR_LIBRARY_NAME="nvidia_only"

# export __NV_PRIME_RENDER_OFFLOAD=1
# export _GLX_VENDOR_LIBRARY_NAME="nvidia"

"${BINARY_PATH}" "$@"

print_separators

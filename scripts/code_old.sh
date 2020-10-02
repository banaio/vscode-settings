#!/usr/bin/env bash
# Usage: code.sh
#
# Documentation: Wrapper to launch VSCode with GPU flags. See:
# * https://www.meshcloud.io/2019/07/17/gpu-acceleration-for-chromium-and-vscode/

UNAME_S=$(uname -s)
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
elif [[ "${UNAME_S}" = "Darwin" ]]; then
  set -euf \
    -o nounset \
    -o errexit \
    -o noclobber \
    -o pipefail
  shopt -s \
    extglob \
    globstar \
    nullglob

  print_separators() {
    printf -- '-%.0s' $(seq 1 $(($(tput cols) - 1)))
    echo
  }
else
  printf '%b' "$(tput bold)" "$(tput setaf 1)" "ERROR: " "$(tput sgr0)" "unsupported platform" "\n"
  exit 1
fi

UNAME_S=$(uname -s)
PATH_CODE=""

if [[ "${UNAME_S}" = "Linux" ]]; then
  PATH_CODE="/usr/bin/code"
elif [[ "${UNAME_S}" = "Darwin" ]]; then
  PATH_CODE="/usr/local/bin/code"
else
  printf '%b' "$(tput bold)" "$(tput setaf 1)" "ERROR: " "$(tput sgr0)" "could not find code (vscode)" "\n"
  exit 1
fi

printf -- "  %b" \
  "UNAME_S=${UNAME_S}" $'\n' \
  "PATH_CODE=${PATH_CODE}" $'\n'

EXAMPLE_STATUS=$(
  cat <<EOF
...
Process Argv:     --ignore-gpu-blacklist --enable-gpu-rasterization --enable-native-gpu-memory-buffers --enable-zero-copy --enable-oop-rasterization --enable-accelerated-2d-canvas --no-sandbox --crash-reporter-id ae62ec6d-5476-4cf7-8548-932b48749ac7
GPU Status:       2d_canvas:                  enabled
                  flash_3d:                   enabled
                  flash_stage3d:              enabled
                  flash_stage3d_baseline:     enabled
                  gpu_compositing:            enabled
                  multiple_raster_threads:    enabled_on
                  oop_rasterization:          enabled
                  opengl:                     enabled_on
                  protected_video_decode:     enabled
                  rasterization:              enabled_force
                  skia_renderer:              enabled_on
                  video_decode:               enabled
                  vulkan:                     disabled_off
                  webgl:                      enabled
                  webgl2:                     enabled
...
EOF
)

echo 'Run the command below in a separate terminal to see output'
printf '%b' "$(tput bold)" "$(tput setaf 2)" "$ ${PATH_CODE} --status" "$(tput sgr0)" "\n"
echo
echo "${EXAMPLE_STATUS}"
echo

print_separators
printf '%b' "launching=" "'" "$(tput bold)" "$(tput setaf 2)" "${PATH_CODE}" "$(tput sgr0)" "'" "\n"
echo

"${PATH_CODE}" --ignore-gpu-blacklist --enable-gpu-rasterization --enable-native-gpu-memory-buffer --enable-zero-copy --enable-oop-rasterization --enable-accelerated-2d-canvas "$@"

print_separators

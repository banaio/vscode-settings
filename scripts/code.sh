#!/usr/bin/env bash
# Usage: code.sh
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
PATH_CODE=""
if [[ "${UNAME_S}" = "Linux" ]]; then
  # set -euf \
  #   -o nounset \
  #   -o errexit \
  #   -o errtrace \
  #   -o noclobber \
  #   -o pipefail \
  #   -o posix \
  #   -o functrace \
  #   -o notify

  # shopt -s \
  #   extglob \
  #   globstar \
  #   nullglob \
  #   failglob \
  #   gnu_errfmt \
  #   localvar_unset \
  #   dotglob \
  #   xpg_echo

  function print_separators() {
    local sep_char="${1:-}"
    printf -- "${sep_char}%.0s" $(seq 1 $(($(tput cols) - ${#sep_char}))) $'\n'
  }

  if [[ -x "$(command -v code 2>/dev/null)" ]]; then
    PATH_CODE="$(command -v code 2>/dev/null)"
  else
    PATH_CODE="/usr/bin/code"
    printf '%b' "$(tput bold)" "$(tput setaf 3)" "WARN: " "$(tput sgr0)" "could not find code in path so using ${PATH_CODE}" "\n"
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

  if [[ -x "$(command -v code 2>/dev/null)" ]]; then
    PATH_CODE="$(command -v code 2>/dev/null)"
  else
    PATH_CODE="/usr/local/bin/code"
    printf '%b' "$(tput bold)" "$(tput setaf 3)" "WARN: " "$(tput sgr0)" "could not find code in path so using ${PATH_CODE}" "\n"
  fi
else
  printf '%b' "$(tput bold)" "$(tput setaf 1)" "ERROR: " "$(tput sgr0)" "unsupported platform" "\n"
  exit 1
fi

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

# NOTICE=$(
#   cat <<EOF
# shellcheck disable=SC2016
NOTICE='Thin stroke font rendering (macOS only)

Thin strokes are suitable for retina displays, but for non-retina screens
it is recommended to set `use_thin_strokes` to `false`

macOS >= 10.14.x:

If the font quality on non-retina display looks bad then set
`use_thin_strokes` to `true` and enable font smoothing by running the
following command:
  `defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO`

This is a global setting and will require a log out or restart to take
effect.'

# Thin stroke font rendering (macOS only)

# Thin strokes are suitable for retina displays, but for non-retina screens
# it is recommended to set \\$(use_thin_strokes) to $(false)

# macOS >= 10.14.x:

# If the font quality on non-retina display looks bad then set
# \\$(use_thin_strokes) to \\$(true) and enable font smoothing by running the
# following command:
#   \\(defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO)

# This is a global setting and will require a log out or restart to take
# effect."

# EOF
# )

echo 'Thin strokes are suitable for retina displays, but for non-retina screens
,e.g., momitors, it is recommended to set to false, please read the guide below:'
printf '%b' "$(tput bold)" "$(tput setaf 3)" "${NOTICE}" "$(tput sgr0)" "\n"
echo
echo 'Run the command below in a separate terminal to see output'
printf '%b' "$(tput bold)" "$(tput setaf 2)" '$ ' "${PATH_CODE}" ' --status' "$(tput sgr0)" "\n"
echo "${EXAMPLE_STATUS}"

print_separators ">"

ARGS_GPU=(
  '--ignore-gpu-blacklist'
  '--enable-gpu-rasterization'
  '--enable-native-gpu-memory-buffer'
  '--enable-zero-copy'
  '--enable-oop-rasterization'
)
# ARGS_CODE=(
#   '--verbose'
#   '--log info'
# )
ARGS_ALL=$(printf '%b' "${ARGS_GPU[*]}")
# ARGS_ALL=$(printf '%b' "${ARGS_GPU[*]}" ' ' "${ARGS_CODE[*]}")

# # modify args to include $(pwd)
# for ((i = 1; i <= $#; i++)); do
#   # printf '%s\n' "Arg $i: ${!i}"
#   if [[ "${!i}" = "." ]]; then
#     # https://stackoverflow.com/a/4827707/241993
#     # printf '%b' "ARGS_ORIGINAL=" "'" "$(tput bold)" "$(tput setaf 2)" "$(echo "$@")" "$(tput sgr0)" "'" "\n"
#     # set -- "${ARGS_ALL}" "${@:1:$i-1}" "$(pwd)" "${@:$i+1:$#}"
#     set -- "${ARGS_ALL}" "${@:1:$i-1}" "." "${@:$i+1:$#}"
#     # printf '%b' "ARGS_MODIFIED=" "'" "$(tput bold)" "$(tput setaf 2)" "$(echo "$@")" "$(tput sgr0)" "'" "\n"
#     break
#   fi
# done

# shellcheck disable=SC2086
set -- ${ARGS_ALL} "${@:1}"

############## shellcheck disable=SC2068,SC2116,SC2046
# shellcheck disable=SC2116
printf '%b' \
  "launching:" "\n" \
  "$(tput bold)" "$(tput setaf 2)" "${PATH_CODE}" ' ' "$(echo "$@")" "$(tput sgr0)" \
  "\n"

print_separators "<"

export TERM="xterm-256color"
set -vx
"${PATH_CODE}" "$@"

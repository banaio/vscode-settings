#!/usr/bin/env bash
SCRIPT_NAME="$(basename "$0")"
SCRIPT_NAME_BASH="$(basename "${BASH_SOURCE[0]}")"
SCRIPT_ARGUMENTS="$@"

PWD="$(pwd)"

# Print shell input lines as they are read.
DEBUG=${DEBUG:=false}
# Print commands and their arguments as they are executed.
# xtrace
TRACE_SCRIPT=${DEBUG:=false}
LOG_LEVEL=${DEBUG:=0}
# Change  the  behavior of bash where the default operation differs from the POSIX standard to match the standard (posix
# mode).  See SEE ALSO below for a reference to a document that details how posix mode affects bash's behavior.
MODE_POSIX=${MODE_POSIX:=true}
# The shell becomes restricted
#
# The shell sets this option if it is started in restricted mode (see RESTRICTED SHELL below).   The  value  may
# not be changed.  This is not reset when the startup files are executed, allowing the startup files to discover
# whether or not a shell is restricted.
#
# turning off restricted mode with set +r or set +o restricted.
set +o restricted
MODE_RESTRICTED=${MODE_RESTRICTED:=true}

function parse_args() {
  local -r optCount="${#}"

  while [[ "${#}" -gt '0' ]]; do
    case "${1}" in
    -t | --trace)
      TRACE="$2"
      shift 2
      ;;
    -l | --log_level)
      # func (l Level) String() string {
      # 	switch l {
      # 	case TraceLevel:
      # 		return "trace"
      # 	case DebugLevel:
      # 		return "debug"
      # 	case InfoLevel:
      # 		return "info"
      # 	case WarnLevel:
      # 		return "warn"
      # 	case ErrorLevel:
      # 		return "error"
      # 	case FatalLevel:
      # 		return "fatal"
      # 	case PanicLevel:
      # 		return "panic"
      # 	case NoLevel:
      # 		return ""
      # 	}
      # 	return ""
      # }
      LOG_LEVEL="$2"
      shift 2
      ;;
    -h | --help)
      displayUsage 0
      ;;

    --identity-file)
      shift

      if [[ "${#}" -gt '0' ]]; then
        local identityFile=''
        identityFile="$(formatPath ${1})"
      fi

      ;;

    --login-name)
      shift

      if [[ "${#}" -gt '0' ]]; then
        local loginName="${1}"
      fi

      ;;

    --address)
      shift

      if [[ "${#}" -gt '0' ]]; then
        local address=''
        address="$(replaceString "${1}" ',' ' ')"
      fi

      ;;

    --command)
      shift

      if [[ "${#}" -gt '0' ]]; then
        local command=''
        command="$(trimString "${1}")"
      fi

      ;;

    *)
      shift
      ;;
    esac
  done

  # Validate Opt

  if [[ "${optCount}" -lt '1' ]]; then
    displayUsage 0
  fi
}

if [[ "${1}" = "-d" ]]; then
  DEBUG=1
  shift
fi

RESET="$(tput sgr0)"
INDENT="$(tput ht)"
BOLD="$(tput bold)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
RED="$(tput setaf 1)"

function on_exit_error_handler() {
  local error_code=${1}
  local command="${*:2}"
  # local command=${@:2}

  if [[ "${error_code}" -ne 0 ]]; then
    SHELL_CURRENT="${SHELL}"
    SHELL_VERSION="$("${SHELL}" --version 2>&1)"
    # SHELL_VERSION=$(echo $("${SHELL}" --version 2>&1))
    PREFIX_STRING="${SCRIPT_NAME}: pwd=${PWD}, end_time=$(get_date_time), error_code=${error_code}, command='${command}', SHELL_CURRENT=${SHELL_CURRENT}, SHELL_CURRENT=${SHELL_VERSION}"
    SEPARATORS="$(get_separators "${PREFIX_STRING}")"
    printf -- "%b" \
      "${BOLD}${RED}" "${PREFIX_STRING}" "${SEPARATORS}" "${RESET}" $'\n'
  else
    PREFIX_STRING="${SCRIPT_NAME}: pwd=${PWD}, end_time=$(get_date_time)"
    SEPARATORS="$(get_separators "${PREFIX_STRING}")"
    printf -- "%b" \
      "${GREEN}" "${PREFIX_STRING}" "${SEPARATORS}" "${RESET}" $'\n'
  fi
}

function on_exit_handler() {
  PREFIX_STRING="${SCRIPT_NAME}: pwd=${PWD}, end_time=$(get_date_time)"
  SEPARATORS="$(get_separators "${PREFIX_STRING}")"
  printf -- "%b" \
    "${GREEN}" "${PREFIX_STRING}" "${SEPARATORS}" "${RESET}" $'\n'
}

trap 'on_exit_error_handler "$?" "$BASH_COMMAND"' INT ERR SIGHUP SIGINT SIGTERM EXIT
# trap 'on_exit_handler "$?" "$BASH_COMMAND"' EXIT INT ERR SIGHUP SIGINT SIGTERM

# https://dustymabe.com/2013/05/17/easy-getopt-for-a-bash-script/
# https://www.bahmanm.com/2015/01/command-line-options-parse-with-getopt.html
FLAG_LIST=(
  "log_level"
)
OPTIONS_LIST=(
  "d"
)

function print_usage_and_exit() {
  DASH_OCTAL="\055"
  ARGS_FOR_SCRIPT=$(
    paste \
      <(printf "%.0s\n" "${FLAG_LIST[@]}") \
      <(printf "[ \055%b\n" "${OPTIONS_LIST[@]}") \
      <(printf "|%.0s\n" "${FLAG_LIST[@]}") \
      <(printf "${DASH_OCTAL}${DASH_OCTAL}%b\n" "${FLAG_LIST[@]}") \
      <(printf "%.0s\n" "${FLAG_LIST[@]}") \
      <(printf "%b ]\n" "${FLAG_LIST[@]^^}")
  )
  USAGE=$(column -e -n -t -c "$(get_separators)" <(echo "${ARGS_FOR_SCRIPT}"))
  EXAMPLE='-d --log_level=trace'

  echo "\
Usage: $0
${USAGE}

Example:
$0 ${EXAMPLE}" >&2
  exit 2
}

function get_date_time() {
  trap 'date_time_ISO_8601' INT ERR SIGINT
  # trap 'date_time_ISO_8601' EXIT
  # trap 'date_time_ISO_8601' EXIT INT ERR SIGINT
  # if anything errors just use manually specified date-time format string
  function date_time_ISO_8601() {
    # 2020-09-25T20:45:44+0000
    DATE_TIME=$(date -u +"%Y-%m-%dT%H:%M:%S%z")
    echo "${DATE_TIME}"
  }

  local UNAME_S=""
  local DATE_TIME=""

  UNAME_S="$(uname -s)"
  if [[ "${UNAME_S}" = "Linux" ]]; then
    # 2020-09-25T20:38:13+00:00
    DATE_TIME=$(date --iso-8601=s --utc)
  fi
  if [[ "${UNAME_S}" = "Darwin" ]]; then
    # Shouldb be ... I hope?
    # 2020-09-25T20:38:13+00:00
    DATE_TIME=$(date -Is -u)
  fi

  printf '%b' "${DATE_TIME}"
}

function get_separators() {
  # echo "0='${0:-0_is_unset}'"
  # echo "1='${1:-1_is_unset}'"
  # echo "@='$@'"
  # https://linuxize.com/post/bash-functions/
  local PREFIX_STRING=${1:+${1} }
  local TRIM_COUNT=${#PREFIX_STRING}

  # echo "TRIM_COUNT='${TRIM_COUNT}'"
  # seq 0 "${TRIM_COUNT}"
  # echo "PREFIX_STRING='${PREFIX_STRING}'"

  WIDTH=$(tput cols)
  TOTAL=$(("${WIDTH}" - "${TRIM_COUNT}"))
  SEPARATORS=$(printf -- '-%.0s' $(seq 1 "${TOTAL}"))

  printf '%b' "${PREFIX_STRING:+ }" "${SEPARATORS}"
}

# https://stackoverflow.com/questions/78497/design-patterns-or-best-practices-for-shell-scripts
# https://opensource.com/article/20/6/bash-functions

function setup_shell_options() {
  set -euf \
    -o nounset \
    -o errexit \
    -o noclobber \
    -o pipefail

  # https://stackoverflow.com/questions/9910966/how-to-get-shell-to-self-detect-using-zsh-or-bash
  # https://stackoverflow.com/a/9911082/241993
  # https://unix.stackexchange.com/questions/9501/how-to-test-what-shell-i-am-using-in-a-terminal
  if [[ "${SHELL}" = "*/bash" ]]; then
    shopt -s \
      extglob \
      globstar \
      nullglob
  fi

  # ----

  # # Tested against Bash 4.4.23(1)-release
  # set -eu -o pipefail

  # set -o noclobber    # Avoid overlay files (echo "hi" > foo)
  # set -o errexit      # Used to exit upon error, avoiding cascading errors
  # set -o pipefail     # Unveils hidden failures
  # set -o nounset      # Exposes unset variables

  # # set -o nullglob     # Non-matching globs are removed  ('*.foo' => '')
  # shopt -s nullglob   # Non-matching globs are removed  ('*.foo' => '')
  # # set -o failglob     # Non-matching globs throw errors
  # shopt -s failglob   # Non-matching globs throw errors
  # # set -o nocaseglob   # Case insensitive globs
  # shopt -s nocaseglob # Case insensitive globs
  # # set -o globstar     # Allow ** for recursive matches ('lib/**/*.rb' => 'lib/a/b/c.rb')
  # shopt -s globstar   # Allow ** for recursive matches ('lib/**/*.rb' => 'lib/a/b/c.rb')

  # #!/usr/bin/env zsh
  # set -ef -o pipefail
  # # set -euf -o pipefail

  # ----

  # # For zsh
  # # setopt -s nullglob   # Non-matching globs are removed  ('*.foo' => '')
  # # setopt -s failglob   # Non-matching globs throw errors
  # # setopt -s nocaseglob # Case insensitive globs
  # # setopt -s globstar # Allow ** for recursive matches ('lib/**/*.rb' => 'lib/a/b/c.rb')

  # ----

  # # GNU bash, version 5.0.17(1)-release (x86_64-pc-linux-gnu)
  # # Copyright (C) 2019 Free Software Foundation, Inc.
  # # License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

  # # This is free software; you are free to change and redistribute it.
  # # There is NO WARRANTY, to the extent permitted by law.

  # # https://sipb.mit.edu/doc/safe-shell/
  # set -euf -o pipefail

  # set -o noclobber    # Avoid overlay files (echo "hi" > foo)
  # set -o errexit      # Used to exit upon error, avoiding cascading errors
  # set -o pipefail     # Unveils hidden failures
  # set -o nounset      # Exposes unset variables

  # # set -o nullglob     # Non-matching globs are removed  ('*.foo' => '')
  # shopt -s nullglob   # Non-matching globs are removed  ('*.foo' => '')
  # # set -o failglob     # Non-matching globs throw errors
  # shopt -s failglob   # Non-matching globs throw errors
  # # set -o nocaseglob   # Case insensitive globs
  # shopt -s nocaseglob # Case insensitive globs
  # # set -o globstar     # Allow ** for recursive matches ('lib/**/*.rb' => 'lib/a/b/c.rb')
  # shopt -s globstar # Allow ** for recursive matches ('lib/**/*.rb' => 'lib/a/b/c.rb')
}

function setup_debug() {
  if [[ "${DEBUG}" = "off" ]]; then
    return 0
  fi

  SHELL_CURRENT="${SHELL}"
  SHELL_VERSION="$("${SHELL}" --version 2>&1)"
  # SHELL_VERSION=$(echo $("${SHELL}" --version 2>&1))
  PREFIX_STRING="${SCRIPT_NAME} - setup_debug - pwd=${PWD}, start_time=$(get_date_time)"
  SEPARATORS="$(get_separators "${PREFIX_STRING}")"
  VALUES_DEBUG=$(
    printf -- "${INDENT}%b" \
      "${YELLOW}BASHOPTS${RESET}=${BASHOPTS}" $'\n' \
      "${YELLOW}SHELLOPTS${RESET}=${SHELLOPTS}" $'\n' \
      "${YELLOW}TERM${RESET}=${TERM}" $'\n' \
      "${YELLOW}SHELL_CURRENT${RESET}=${SHELL_CURRENT}" $'\n' \
      "${YELLOW}SHELL_VERSION${RESET}=${SHELL_VERSION}" $'\n'
  )

  printf -- "%b" \
    "${YELLOW}" "$(get_separators)" "${RESET}" $'\n' \
    "${YELLOW}" "${PREFIX_STRING}" "${SEPARATORS}" "${RESET}" $'\n' \
    "${YELLOW}" "${VALUES_DEBUG}" "${RESET}" $'\n' \
    "${YELLOW}" "$(get_separators)" "${RESET}" $'\n'
}

function setup_aliases() {
  alias cp='cp -v'
  alias rm='rm -v'
  alias mkdir='mkdir -v'
}

function setup() {
  setup_shell_options
  setup_debug
  setup_aliases
}

function print_script_banner() {
  PREFIX_STRING="${SCRIPT_NAME} - pwd=${PWD}, start_time=$(get_date_time)"

  SEPARATORS="$(get_separators "${PREFIX_STRING}")"
  printf -- "%b" \
    "${GREEN}" "${PREFIX_STRING}" "${SEPARATORS}" "${RESET}" $'\n'
}

function print_script_vars() {
  printf -- "${INDENT}%b" \
    "${GREEN}SOME_VAR${RESET}=${SOME_VAR}" $'\n'
}

# function print_env() {
#   print_separator_v2 "print_env" ":  "
#   local BUILD_VARS=("SHELL_CURRENT" "SHELL_VERSION" "UNAME_S" "PWD" "INSTALL_COMMAND" "DEBIAN_FRONTEND" "PKG_MANAGER_INSTALL_COMMAND" "SCRIPT_NAME")
#   print_vars=$(printf '%s\0' "${BUILD_VARS[@]}" | xargs -0 -n1 -IV bash -c 'echo -en "${INDENT}${GREEN}V${RESET}=$V\n"' | sort -i)
#   echo "${print_vars}"
# }

setup

SOME_VAR=""
export SOME_VAR

print_script_banner
print_script_vars

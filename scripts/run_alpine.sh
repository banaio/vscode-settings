#!/usr/bin/env bash
# Usage:
# ./scripts/run_alpine.sh
#
# Runs Alpine image with bash
docker run \
  --interactive \
  --tty \
  --rm \
  'golang:1.13.4-alpine3.10' \
  sh -c 'apk --no-cache update --no-cache && apk --no-cache add --no-cache bash bash-doc bash-completion grep findutils ncurses gawk coreutils binutils man man-pages mdocml-apropos man-pages mdocml-apropos less less-doc && bash'

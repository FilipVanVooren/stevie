#!/usr/bin/env bash

################################################################################
# Shared shell helpers for the build scripts in build/ and build/lib/.
#
# Sourced, never executed:
#     source "$LIB_DIR/helper.sh"
################################################################################

function log() {
      vnow="$(date '+%y-%m-%d %H:%M:%S')"        # Current date & time format 2
      msg="$*"
      echo "${vnow}  ${msg}"
}

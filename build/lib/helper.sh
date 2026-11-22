#!/usr/bin/env bash

function log() {
      vnow="$(date '+%y-%m-%d %H:%M:%S')"        # Current date & time format 2
      msg="$*"
      echo "${vnow}  ${msg}"
}

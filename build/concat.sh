#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2086,SC2181

set -e
source helper.sh

# Variables
image="$1"
shift
start="$(date +%s%N | cut -b1-13)"

log "Concatenating binaries to final binary $image"

rm -f "$image"

for bin in "$@";
do
    filebin="bin/${bin}.bin"

    if [ -f "$filebin" ]; then
        log "    Adding $filebin ...."
        cat "$filebin" >>"${image}"
    else
        log "    Could not find $filebin ...."
        log "    Removing inconsistent binary: $image"
        rm -f "$image"
        exit 255
    fi
done

# Write time spend
now=$(date +%s%N | cut -b1-13)
dur=$((now-start))
log "    Time spend: $dur ms"


log "Concatenation done."

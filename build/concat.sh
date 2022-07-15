#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2086,SC2181

set -e
source helper.sh

image="$1"
shift

log "Concatenating binaries to image $image"

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

log "Concatenation done."

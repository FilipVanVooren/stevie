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
    log "    Adding ${bin}.bin ...."
    cat "bin/${bin}.bin" >>"${image}"
done

log "Concatenation done."

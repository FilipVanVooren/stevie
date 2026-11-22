#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2086,SC2181

# Concatenates the bank images in build/bin/ into one cartridge image.
# Usage: lib/concat.sh <output-image> <bank> [<bank> ...]; runnable from any
# directory because all paths are resolved relative to build/.

set -e

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$(dirname "$LIB_DIR")"
cd "$BUILD_DIR" || exit 1

source "$LIB_DIR/helper.sh"

# Variables
image="$1"
shift
start=$EPOCHREALTIME                       # High resolution, bash >5.x required

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
dur=$(echo "scale=1; ($EPOCHREALTIME-$start)*1000/1" | bc)
log "    Time spend: $dur ms"
log "Concatenation done."

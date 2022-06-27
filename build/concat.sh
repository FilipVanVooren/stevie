#!/usr/bin/env bash

set -e

vnow="$(date '+%y-%m-%d %H:%M:%S')"        # Current date & time format 2
image="$1"
shift

echo "$vnow  Concatenating binaries to binary image $image"

rm -f "$image"

for bin in "$@";
do
    echo "$vnow        Adding ${bin}.bin ...."
    cat "bin/${bin}.bin" >>"${image}"
done

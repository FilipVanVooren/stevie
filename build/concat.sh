#!/usr/bin/env

set -e

binary="$1"
shift

echo "Concatenating binaries to $binary"

rm -f "$binary"

for bin in "$@";
do
    echo "   Adding ${bin}.bin ...."
    cat "bin/${bin}.bin" >>"${binary}"
done

#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2086,SC2181

set -e

# Layout: entry points live in build/, shell helpers in build/lib/.
# Resolve them from this script's location and work from build/ so all
# relative paths (bin/, list/, .buildinfo/) stay valid.
BUILD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$BUILD_DIR/lib"
cd "$BUILD_DIR" || exit 1

source "$LIB_DIR/helper.sh"

# Banks and destination binary (the image needs all 16 banks, even when only
# one of them is re-assembled)
banks="stevie_b0 stevie_b1 stevie_b2 stevie_b3"
banks+=" stevie_b4 stevie_b5 stevie_b6 stevie_b7"
banks+=" stevie_b8 stevie_b9 stevie_ba stevie_bb"
banks+=" stevie_bc stevie_bd stevie_be stevie_bf"

binary="bin/stevie.bin"

# Directories
workdir="/workspace/stevie/src"
include="../../spectra2/src/equates,../../spectra2/src/modules,"
include+="../../spectra2/src,../src/modules/,../src,../build/.buildinfo"

export xas99_options="-D vdpmode=3080"


# Call xas99 wrapper
if [[ "$1" =~ ^[0-9a-f]$ ]]; then
    workdir="$workdir" include=$include bash "$LIB_DIR/assemble.sh" "stevie_b$1"
else
    log "**** Error **** No bank number 0-f specified. Terminated."
    exit 1
fi

if [ "$?" -eq "0" ]; then
    bash "$LIB_DIR/concat.sh" "$binary" $banks
else
    log "**** Error **** Error during assembly process. Terminated."
fi

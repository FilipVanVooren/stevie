#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2086,SC2181

set -e
source helper.sh

# Banks and destination binary
banks="stevie_b0 stevie_b1 stevie_b2 stevie_b3"
banks+=" stevie_b4 stevie_b5 stevie_b6 stevie_b7"
binary="bin/stevie.bin"

# Directories
workdir="/workspace/stevie/src"
include="../../spectra2/src/equates,../../spectra2/src/modules,"
include+="../../spectra2/src,../src/modules/,../src,.buildinfo"

# Call xas99 wrapper
if [[ "$1" =~ ^[0-9]+$ ]]; then
    workdir="$workdir" include=$include bash assemble.sh "stevie_b$1"
else
    log "**** Error **** No bank number 0-9 specified. Terminated."
    exit 1
fi

if [ "$?" -eq "0" ]; then
    bash concat.sh "$binary" $banks
else
    log "**** Error **** Error during assembly process. Terminated."
fi

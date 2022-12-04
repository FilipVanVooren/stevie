#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2086,SC2181

set -e
source helper.sh

# Constants
IMAGE="${IMAGE:-easyxdt99:3.5.0-cpython3.11-alpine}"

# Banks and destination binary
banks="stevie_b0 stevie_b1 stevie_b2 stevie_b3"
banks+=" stevie_b4 stevie_b5 stevie_b6 stevie_b7"
binary="bin/stevie24.bin"

# Directories
workdir="/workspace/stevie/src"
include="../../spectra2/src/equates,../../spectra2/src/modules,"
include+="../../spectra2/src,../src/modules/,../src,../build/.buildinfo"

# Call xas99 wrapper
log "Building stevie (24x80) version"
export workdir="$workdir"
export include="$include"
export xas99_options="-D full_f18a_support=0"
bash assemble.sh $banks

# Concatenate banks to binary
if [ "$?" -eq "0" ]; then
    bash concat.sh "$binary" $banks
else
    log "**** Error **** Error during assembly process. Terminated."
fi

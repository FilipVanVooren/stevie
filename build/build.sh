#!/usr/bin/env bash

################################################################################
# Stevie Cartridge Binary Builder
# Author: Filip van Vooren
#
#
# Always run shellcheck 
################################################################################
# shellcheck disable=SC1091,SC2086,SC2181


set -e
source helper.sh


setbin() {    
    vdpmode="${1:-3080}"
    case "$vdpmode" in
        # F18a/PICO9918 24x80
        2480)
          binary="stevie24.bin"
          return
          ;;

        # F18a/PICO9918 30x80
        3080)
          binary="stevie30.bin"
          return          
          ;;

        # PICO9918 48x80
        4880)
          binary="stevie48.bin"
          return          
          ;;

        # F18a 60x80
        6080)
          binary="stevie60.bin"
          return          
          ;;

        *)
          echo "**** Error **** Unsupported VDP mode $vdpmode. Aborting!"
          exit 1
          ;;
   esac
}

# Constants
IMAGE="${IMAGE:-easyxdt99:3.5.0-cpython3.11-alpine}"

# Banks
banks="stevie_b0 stevie_b1 stevie_b2 stevie_b3"
banks+=" stevie_b4 stevie_b5 stevie_b6 stevie_b7"
banks+=" stevie_b8 stevie_b9 stevie_ba stevie_bb"
banks+=" stevie_bc stevie_bd stevie_be stevie_bf"

# VDP mode
vdpmode="$1"

# Directories
workdir="/workspace/stevie/src"
include="../../spectra2/src/equates,../../spectra2/src/modules,"
include+="../../spectra2/src,../src/modules/,../src,../build/.buildinfo,"
include+="../src/assets/"

# Set name of output binary
setbin "$vdpmode"

# Call xas99 wrapper
log "Building stevie binary for vdp mode $vdpmode"
export workdir="$workdir"
export include="$include"
export xas99_options="-D vdpmode=$vdpmode"
bash assemble.sh $banks

# Concatenate banks to binary
if [ "$?" -eq "0" ]; then
    bash concat.sh "bin/$binary" $banks
else
    log "**** Error **** Error during assembly process. Terminated."
fi

# Copy final binary to output directory
if [ -f "bin/$binary" ]; then
   cp "bin/$binary" /Volumes/FINALGROM
    log "Final binary copied to /Volumes/FINALGROM/$binary"
fi

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
        # F18a 24x80 sprite cursor/ruler
        2480)
          binary="stevie24.bin"
          return
          ;;

        # F18a 24x80 character cursor
        2481)
          binary="stevie24.bin"
          return          
          ;;

        # F18a 30x80 sprite cursor/ruler
        3080)
          binary="stevie.bin"
          return          
          ;;

        # F18a 30x80 character cursor
        3081)
          binary="stevie.bin"
          return          
          ;;

        # F18a 60x80 character cursor
        6081)
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

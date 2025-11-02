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
          binary="stevie24s.bin"
          return
          ;;

        # F18a 24x80 character cursor
        2481)
          binary="stevie24t.bin"
          return          
          ;;

        # F18a 30x80 sprite cursor/ruler
        3080)
          binary="stevie30s.bin"
          return          
          ;;

        # F18a 30x80 character cursor
        3081)
          binary="stevie30t.bin"
          return          
          ;;

        # F18a 60x80 character cursor
        6081)
          binary="stevie60t.bin"
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

# Cartridge XML metadata for RPK/ZIP package
metadata=$(cat << EOF
<?xml version="1.0" encoding="utf-8"?>
<romset version="1.0">
   <resources>
      <rom id="romimage" file="${binary}"/>
      <rom id="gromimage" file="phm3055g3.bin"/>
   </resources>
   <configuration>
      <pcb type="gromemu">
         <socket id="grom_socket" uses="gromimage"/>
         <socket id="rom_socket" uses="romimage"/>
      </pcb>
   </configuration>
</romset>
EOF
)

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

# Create RPK package
if [ -f "bin/$binary" ]; then
    rpkname="${binary//.bin/.rpk}"
    metaname="layout.xml"
    rm -f "bin/$rpkname" "$metaname"
    log "Creating RPK package $rpkname"
    echo "$metadata" > "bin/$metaname"
    zip -q -j "bin/$rpkname" "bin/$binary" "bin/phm3055g3.bin" "bin/$metaname"
    log "RPK package created: bin/$rpkname"
    zip -T "bin/$rpkname" 
    unzip -l "bin/$rpkname" 
else
    log "**** Error **** Final binary bin/$binary not found. Cannot create RPK package."
    exit 1
fi


# Copy final binaries to FINALGROM volume if it exists
if [ -f "bin/$binary" ]; then
   if [ -d "/Volumes/FINALGROM" ]; then
      cp "bin/$binary" /Volumes/FINALGROM/STEVIEC.bin
      cp "bin/phm3055g3.bin" /Volumes/FINALGROM/STEVIEG.bin
      log "Final binary copied to /Volumes/FINALGROM/$binary"
   else
      log "FINALGROM volume not mounted, skipping copy operation"
   fi
fi
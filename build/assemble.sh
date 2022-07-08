#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2086,SC2181

set -e
source helper.sh

# Variables
include="../../spectra2/src/equates,../../spectra2/src/modules,"
include+="../../spectra2/src,../src/modules/,../src,.buildinfo"
marker="***************************************************************"

mkdir -p .buildinfo

count=0
for src in "$@"
do
      vdate="$(date '+%y%m%d-%H%M%S0')"          # Current date & time format 1

      if [[ "$count" -eq "0" ]]; then
            log "Assembly started"
      fi

      # Write asm file with build info
      echo "$marker"                             > ./.buildinfo/buildinfo.asm
      echo "* BUILD: $vdate "                   >> ./.buildinfo/buildinfo.asm
      echo "$marker"                            >> ./.buildinfo/buildinfo.asm
      echo "                   text '${vdate}'"  > ./.buildinfo/buildstr.asm

      # Start assembly
      ((count+=1))
      main="${src:-main}"
      list="${main}.lst"

      log "    Assembling ${main}.asm ...."

      xas99.py --quiet-unused-syms              \
               --quiet-opts                     \
               --listing-file "list/${list}" -S \
               -b                               \
               -o bin                           \
               "$main.asm" -I "$include"        \
               -D build_date="$vdate" &

      pids[count]=$!
done

# wait for assembly subprocesses
for pid in "${pids[@]}"; do
    wait $pid
done

if (( count > 0 )); then
      log "Assembly completed"
else
      log "Nothing to assemble"
fi

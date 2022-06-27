#!/usr/bin/env bash

set -e

include="../../spectra2/src/equates,../../spectra2/src/modules,"
include+="../../spectra2/src,../src/modules/,../src,.buildinfo"
marker="***************************************************************"

mkdir -p .buildinfo

count=0
for src in "$@"
do
      vdate="$(date '+%y%m%d-%H%M%S0')"          # Current date & time format 1
      vnow="$(date '+%y-%m-%d %H:%M:%S')"        # Current date & time format 2

      # Write asm file with build info
      echo "$marker"                             > ./.buildinfo/buildinfo.asm
      echo "* BUILD: $vdate "                   >> ./.buildinfo/buildinfo.asm
      echo "$marker"                            >> ./.buildinfo/buildinfo.asm
      echo "                   text '${vdate}'"  > ./.buildinfo/buildstr.asm

      # Start assembly
      ((count+=1))
      main="${src:-main}"
      list="${main}.lst"
      bin="${main}.bin"

      echo "$vnow  Assembling ${main}.asm ...."

      xas99 --quiet-unused-syms              \
            --quiet-opts                     \
            --listing-file "list/${list}" -S \
            -b                               \
            "$main.asm" -I "$include"        \
            -D build_date="$vdate"

      mv "$bin" "bin/$bin"
done

if (( count > 0 )); then
      echo "$vnow  Assembly completed"
else
      echo "$vnow  Nothing to assemble"
fi

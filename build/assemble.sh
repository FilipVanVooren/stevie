#!/usr/bin/env bash

set -e

include="../../spectra2/src/equates,../../spectra2/src/modules,../../spectra2/src,../src/modules/,../src"

for src in "$@"
do
      main="${src:-main}"
      list="${main}.lst"
      bin="${main}.bin"

      echo "Assembling ${main}.asm ..."

      xas99 --quiet-unused-syms              \
            --quiet-opts                     \
            --listing-file "list/${list}" -S \
            -b \
            "$main.asm" -I "$include"

      mv "$bin" "bin/$bin"
done

echo "Assembly completed"

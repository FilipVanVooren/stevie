#!/usr/bin/env bash

options="--quiet-unused-syms"
include="../../spectra2/src/equates,../../spectra2/src/modules,../../spectra2/src,../src/modules/,../src"

xas99 "$options" stevie_b0.asm -I "$include"

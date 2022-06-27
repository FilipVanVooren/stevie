#!/usr/bin/env bash
# shellcheck disable=SC2086,SC2181

set -e

vnow="$(date '+%y-%m-%d %H:%M:%S')"        # Current date & time format 2
banks="stevie_b0 stevie_b1 stevie_b2 stevie_b3 stevie_b4 stevie_b5 stevie_b6 stevie_b7"
stevie="bin/stevie.bin"

if [[ "$1" =~ ^[0-9]+$ ]]; then
    bash assemble.sh "stevie_b$1"
else
    echo "$vnow **** Error **** No bank number 0-9 specified. Terminated."
    exit 1
fi

if [ "$?" -eq "0" ]; then
    bash concat.sh "$stevie" $banks
else
    echo "$vnow **** Error **** Error during assembly process. Terminated."
fi
echo "$vnow **** Done ****"

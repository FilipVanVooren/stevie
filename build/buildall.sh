#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2086,SC2181

set -e
source helper.sh

banks="stevie_b0 stevie_b1 stevie_b2 stevie_b3 stevie_b4 stevie_b5 stevie_b6 stevie_b7"
stevie="bin/stevie.bin"

bash assemble.sh $banks
if [ "$?" -eq "0" ]; then
    bash concat.sh "$stevie" $banks
else
    log "**** Error **** Error during assembly process. Terminated."
fi
log "**** Done ****"

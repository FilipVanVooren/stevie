#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2086,SC2181

source helper.sh

# Constants
IMAGE="${IMAGE:-easyxdt99:3.5.0-cpython3.10}"

# Variables
marker="***************************************************************"
vdate="$(date '+%y%m%d-%H%M%S0')"          # Current date & time format 1

# Check if xas99.py available
xas99found="$(which xas99.py)" || true

# Cache
mkdir -p .buildinfo

# Write asm file with build info
echo "$marker"                             > ./.buildinfo/buildinfo.asm
echo "* BUILD: $vdate "                   >> ./.buildinfo/buildinfo.asm
echo "$marker"                            >> ./.buildinfo/buildinfo.asm
echo "                   text '${vdate}'"  > ./.buildinfo/buildstr.asm

# Loop over assembly main files
count=0
for src in "$@"
do
      if [[ "$count" -eq "0" ]]; then
            log "Assembly started"
      fi

      # Start assembly
      ((count+=1))
      main="${src:-main}"
      list="${main}.lst"

      if [ "${#xas99found}" -gt "0" ]; then
            # run on host (or in devcontainer)
            log "    Assembling ${main}.asm ...."

            #shellcheck disable=SC2140,SC2154
            xas99.py --quiet-unused-syms           \
                  --quiet-opts                     \
                  --listing-file "list/${list}" -S \
                  -b                               \
                  -o bin                           \
                  "$main.asm" -I "$include"        \
                  -D build_date="$vdate" &

            pids[count]=$!

      else
            # Spin easyxdt99 container
            container="easyxdt99-xas99-$main-$$.asm"
            log "    Assembling ${main}.asm in container .... $container"

            #shellcheck disable=SC2140,SC2154
            docker run \
                  --mount type=bind,source="$(pwd)/../../",target="/workspace" \
                  --workdir "$workdir"     \
                  --env main="$main"       \
                  --env include="$include" \
                  --env list="$list"       \
                  --env vdate="$vdate"     \
                  --name "$container"      \
                  $IMAGE                   \
                  xas99.py \
                        --quiet-unused-syms              \
                        --quiet-opts                     \
                        --listing-file "list/${list}" -S \
                        -b                               \
                        -o bin                           \
                        "$main.asm" -I "$include"        \
                        -D build_date="$vdate" &

            pids[count]=$!
      fi
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

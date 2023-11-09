#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2086,SC2181

source helper.sh

# Constants
IMAGE="${IMAGE:-easyxdt99:3.5.0-cpython3.11-alpine}"

# Variables
marker="***************************************************************"
vdate="$(date '+%y%m%d-%H%M%S0')"          # Current date & time format 1
start=$EPOCHREALTIME                       # High resolution, bash >5.x required
cid=""                                     # Docker container ID

# Check if xas99.py available
xas99found="$(which xas99.py)" || true

# Cache
mkdir -p .buildinfo

# Write asm file with build info
echo "$marker"                             > ./.buildinfo/buildinfo.asm
echo "* BUILD: $vdate "                   >> ./.buildinfo/buildinfo.asm
echo "$marker"                            >> ./.buildinfo/buildinfo.asm
echo "                   text '${vdate}'"  > ./.buildinfo/buildstr.asm

# Spin-up container if no xas99 found in host environment
if [ "${#xas99found}" -eq "0" ]; then
      # Prepare for startup
      container="easyxdt99-xas99-$$.asm"
      count=0

      #shellcheck disable=SC2140,SC2154
      docker run \
            --mount type=bind,source="$(pwd)/../../",target="/workspace" \
            --workdir "$workdir"     \
            --name "$container"      \
            $IMAGE                   \
            sleep infinity &

      # Spin loop wait for container to start
      while true; do
        cid=$(docker container ls --quiet --filter "name=^${container}$")
        sleep 0.1
        if [ "${#cid}" -gt 0 ]; then 
          log "    Container started with container ID $cid ...."      
          break;
        else 
          ((count+=1))
          if [[ "$count" -eq "50" ]]; then
             log "    Could not start container yet. Will wait longer, if"
             log "    you see any error messages, then now is a good time"
             log "    to terminate with CTRL-break ^C"
          elif [[ "$count" -eq "250" ]]; then
             log "    Gave up on starting container. Will abort now."
             exit 1
          fi
      fi
      done
fi

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
                  -D build_date="$vdate"           \
                  ${xas99_options} &
      else
            #  Run in existing easyxdt99 container
            log "    Assembling ${main}.asm in container $cid (docker $IMAGE)"

            #shellcheck disable=SC2140,SC2154
            docker \
              exec \
              --env main="$main"       \
              --env include="$include" \
              --env list="$list"       \
              --env vdate="$vdate"     \
              "${cid}"                 \
                xas99.py               \
                  --quiet-unused-syms  \
                  --quiet-opts         \
                  --listing-file "/workspace/stevie/build/list/${list}" \
                  -S                               \
                  -b                               \
                  -o "/workspace/stevie/build/bin" \
                  "$main.asm" -I "$include"        \
                  -D build_date="$vdate"           \
                  ${xas99_options} &
      fi
      pids[count]=$!
done

# wait for assembly subprocesses
for pid in "${pids[@]}"; do
    wait $pid
    exits[pid]=$?
done

# Remove container
if [ "${#cid}" -gt 0 ]; then
   log "    Terminating container $cid"
   cid=$(docker rm --force "$cid")
fi

# Write time spend
dur=$(echo "scale=1; ($EPOCHREALTIME-$start)*1000/1" | bc)
log "    Time spend: $dur ms"

# Exit with error if any of the processes returned > 0
for excode in "${exits[@]}"; do
    if (( excode > 0 )); then
        log "    Assembly process returned with exit code ${excode} > 0"
        log "Assembly aborted"
        exit $excode
    fi
done

if (( count > 0 )); then
      log "Assembly completed"
else
      log "Nothing to assemble"
fi

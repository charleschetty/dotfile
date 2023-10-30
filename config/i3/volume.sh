#!/bin/sh

# Wait for amixer to become available
until [ "$(amixer)" ]; do sleep 0.1; done

# `amixer events` always emits 1 event from the start, so we must skip it
skip=1
stdbuf -oL amixer events |
  while IFS= read -r line; do
    case ${line%%,*} in
      ('event value: numid='[34])
        if [ "$skip" -eq 0 ]; then
          # The `0+$2` below is to remove the '%' sign
          # amixer sget Master |
            # awk -F'[][]' '/Left:/ {print 0+$2 ($4 == "off" ? "!" : "")}'

          # Using Pipewire/Wireplumber:
          wpctl get-volume @DEFAULT_AUDIO_SINK@ |
           awk '{ gsub(/\./, "", $2); print $2 ($3 == "[MUTED]" ? "!" : "")}'
        else
          skip=$(( skip - 1 ))
        fi
    esac
  done | xob 

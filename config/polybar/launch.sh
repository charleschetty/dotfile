#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# if type "xrandr"; then
#   for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#     MONITOR=$m polybar -reload main -c ~/.config/polybar/1/config.ini &
#   done
# else
#   polybar -reload main -c ~/.config/polybar/1/config.ini &
# fi
# Launch the bar
polybar -q main -c "$DIR"/config.ini &

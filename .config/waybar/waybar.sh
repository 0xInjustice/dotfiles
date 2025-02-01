#!/bin/bash
# waybar-toggle.sh

# Check if Waybar is running
if pgrep -x "waybar" > /dev/null; then
  # If Waybar is running, kill it to hide
  killall waybar
else
  # If Waybar is not running, start it
  waybar &
fi


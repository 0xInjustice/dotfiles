#!/usr/bin/env bash

# ─── CONFIGURATION ────────────────────────────────────
# Directory containing your wallpapers
WALLPAPER_DIR="~/dotfiles/ignores/wallpapers/wallpaper.sh"
# Rotation interval in seconds (default: 900s = 15 minutes)
INTERVAL="${1:-900}"

# ─── DISCOVER MONITORS ─────────────────────────────────
# Build an array of monitor names (e.g. "eDP-1", "HDMI-A-1")
mapfile -t MONITORS < <(
  hyprctl monitors \
    | awk '/Monitor/ { print $2 }'
)
if (( ${#MONITORS[@]} == 0 )); then
  echo "Error: no monitors detected." >&2
  exit 1
fi

# ─── ROTATION LOOP ────────────────────────────────────
while true; do
  # Pick a random file (JPG/PNG) safely, including subfolders
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f \
                \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) \
                -print0 \
             | shuf -zn1 \
             | xargs -0)

  if [[ -z "$WALLPAPER" ]]; then
    echo "No wallpapers found in $WALLPAPER_DIR" >&2
    exit 1
  fi

  # Preload and apply to each monitor via IPC
  hyprctl hyprpaper preload "$WALLPAPER"
  for M in "${MONITORS[@]}"; do
    hyprctl hyprpaper wallpaper "${M},${WALLPAPER}"
  done

  # Unload all other images to free memory
  hyprctl hyprpaper unload unused

  # Wait before next rotation
  sleep "$INTERVAL"
done


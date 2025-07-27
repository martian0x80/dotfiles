#!/bin/bash
# Cleaned wallpaper selector for Niri using `swww` and `rofi`

wallDIR="$HOME/Pictures/wallpapers"
rofi_theme="$HOME/.config/rofi/config-wallpaper.rasi"
wallpaper_current="$HOME/.config/niri/.wallpaper_current"

# swww transition settings
FPS=60
TYPE="any"
DURATION=2
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"

# Ensure swww-daemon is running
if ! pgrep -x "swww-daemon" >/dev/null; then
  swww-daemon --format xrgb &
  sleep 1
fi

# Collect wallpaper files
mapfile -d '' PICS < <(find -L "$wallDIR" -type f \( \
  -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o \
  -iname "*.bmp" -o -iname "*.tiff" -o -iname "*.webp" \) -print0)

# Generate rofi menu
menu() {
  IFS=$'\n' sorted_options=($(sort <<<"${PICS[*]}"))
  for pic_path in "${sorted_options[@]}"; do
    pic_name=$(basename "$pic_path")
    printf "%s\x00icon\x1f%s\n" "$(echo "$pic_name" | cut -d. -f1)" "$pic_path"
  done
}

# Rofi command
rofi_command="rofi -i -show -dmenu -config $rofi_theme"

# Main logic
main() {
  choice=$(menu | $rofi_command)
  choice=$(echo "$choice" | xargs)

  if [[ -z "$choice" ]]; then
    exit 0
  fi

  choice_basename=$(basename "$choice" | sed 's/\(.*\)\.[^.]*$/\1/')
  selected_file=$(find "$wallDIR" -iname "$choice_basename.*" -print -quit)

  if [[ -z "$selected_file" ]]; then
    exit 1
  fi

  # Set wallpaper
  swww img "$selected_file" $SWWW_PARAMS

  # Store current wallpaper path
  mkdir -p "$(dirname "$wallpaper_current")"
  echo "$selected_file" > "$wallpaper_current"
}

# Kill any existing rofi instances
pkill rofi 2>/dev/null

main


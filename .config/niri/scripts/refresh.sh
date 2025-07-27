#!/bin/bash
# Refresh Waybar, Rofi, SwayNC

# Kill running UI processes
pkill waybar
pkill rofi
pkill swaync

# Force Waybar refresh (some styles need signal)
killall -SIGUSR2 waybar 2>/dev/null

# Restart Waybar
sleep 1
waybar &

# Restart swaync
sleep 0.5
swaync >/dev/null 2>&1 &
swaync-client --reload-config

# Optional: Launch RainbowBorders if script exists
#rainbow_script="$HOME/.config/niri/UserScripts/RainbowBorders.sh"
#[[ -f "$rainbow_script" ]] && "$rainbow_script" &


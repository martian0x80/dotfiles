#!/bin/bash
# Switch Waybar layout configs

layout_dir="$HOME/.config/waybar/configs"
active_config="$HOME/.config/waybar/config"
refresh_script="$HOME/.config/niri/scripts/refresh.sh"
rofi_config="$HOME/.config/rofi/config-waybar-layout.rasi"
msg=" 🎌 NOTE: Some Waybar LAYOUTS may not match all STYLES"

apply_config() {
    ln -sf "$layout_dir/$1" "$active_config"
    "$refresh_script" &
}

main() {
    current_target=$(readlink -f "$active_config")
    current_name=$(basename "$current_target")

    mapfile -t options < <(find -L "$layout_dir" -maxdepth 1 -type f -printf '%f\n' | sort)
    default_row=0
    marker="👉"

    for i in "${!options[@]}"; do
        [[ "${options[i]}" == "$current_name" ]] && { options[i]="$marker ${options[i]}"; default_row=$i; break; }
    done

    choice=$(printf '%s\n' "${options[@]}" | rofi -i -dmenu -config "$rofi_config" -mesg "$msg" -selected-row "$default_row")
    [[ -z "$choice" ]] && exit 0
    choice=${choice# $marker}

    [[ "$choice" == "no panel" ]] && pkill waybar || apply_config "$choice"
}

pkill rofi 2>/dev/null
main


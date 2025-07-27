#!/bin/bash
# Switch Waybar styles

style_dir="$HOME/.config/waybar/style"
active_style="$HOME/.config/waybar/style.css"
refresh_script="$HOME/.config/niri/scripts/refresh.sh"
rofi_config="$HOME/.config/rofi/config-waybar-style.rasi"
msg=" 🎌 NOTE: Some STYLES may not match all LAYOUTS"

apply_style() {
    ln -sf "$style_dir/$1.css" "$active_style"
    "$refresh_script" &
}

main() {
    current_target=$(readlink -f "$active_style")
    current_name=$(basename "$current_target" .css)

    mapfile -t options < <(find -L "$style_dir" -maxdepth 1 -type f -name '*.css' -exec basename {} .css \; | sort)
    default_row=0
    marker="👉"

    for i in "${!options[@]}"; do
        [[ "${options[i]}" == "$current_name" ]] && { options[i]="$marker ${options[i]}"; default_row=$i; break; }
    done

    choice=$(printf '%s\n' "${options[@]}" | rofi -i -dmenu -config "$rofi_config" -mesg "$msg" -selected-row "$default_row")
    [[ -z "$choice" ]] && exit 0
    choice=${choice# $marker}

    apply_style "$choice"
}

pkill rofi 2>/dev/null
main


#!/bin/bash

# Directory music folder
mDIR="$HOME/Music/"

# Directory for icons
iDIR="$HOME/.config/swaync/icons"

# Online Stations
declare -A online_music=(
  ["AfroBeatz 2024 🎧"]="https://www.youtube.com/watch?v=7uB-Eh9XVZQ"
  ["Lofi Girl ☕️🎶"]="https://play.streamafrica.net/lofiradio"
  ["Easy Rock 96.3 FM 📻🎶"]="https://radio-stations-philippines.com/easy-rock"
  ["Wish 107.5 FM 📻🎶"]="https://radio-stations-philippines.com/dwnu-1075-wish"
  ["Wish 107.5 YT Pinoy HipHop 🎻🎶"]="https://youtube.com/playlist?list=PLkrzfEDjeYJnmgMYwCKid4XIFqUKBVWEs&si=vahW_noh4UDJ5d37"
  ["Top Youtube Music 2023 ☕️🎶"]="https://youtube.com/playlist?list=PLDIoUOhQQPlXr63I_vwF9GD8sAKh77dWU&si=y7qNeEVFNgA-XxKy"
  ["Wish 107.5 YT Wishclusives ☕️🎶"]="https://youtube.com/playlist?list=PLkrzfEDjeYJn5B22H9HOWP3Kxxs-DkPSM&si=d_Ld2OKhGvpH48WO"
  ["Chillhop ☕️🎶"]="http://stream.zeno.fm/fyn8eh3h5f8uv"
  ["SmoothChill ☕️🎶"]="https://media-ssl.musicradio.com/SmoothChill"
  ["Relaxing Music ☕️🎶"]="https://youtube.com/playlist?list=PLMIbmfP_9vb8BCxRoraJpoo4q1yMFg4CE"
  ["Youtube Remix 📻🎶"]="https://youtube.com/playlist?list=PLeqTkIUlrZXlSNn3tcXAa-zbo95j0iN-0"
  ["Korean Drama OST 📻🎶"]="https://youtube.com/playlist?list=PLUge_o9AIFp4HuA-A3e3ZqENh63LuRRlQ"
)

# Local Music
# Populate local_music array with files from music directory and subdirectories
populate_local_music() {
  local_music=()
  filenames=()
  while IFS= read -r file; do
    local_music+=("$file")
    filenames+=("$(basename "$file")")
  done < <(find "$mDIR" -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.ogg" \))
}

# Function for displaying notifications
notification() {
  notify-send -u normal -i "$iDIR/music.png" "Playing: $@"
}

# Main function for playing local music
play_local_music() {
  populate_local_music

  # Prompt the user to select a song
  choice=$(printf "%s\n" "${filenames[@]}" | rofi -i -dmenu -config ~/.config/rofi/config-rofi-Beats.rasi -p "Local Music")

  if [ -z "$choice" ]; then
    exit 1
  fi

  # Find the corresponding file path based on user's choice
  for (( i=0; i<"${#filenames[@]}"; i++ )); do
    if [ "${filenames[$i]}" = "$choice" ]; then
      file="${local_music[$i]}"
      break
    fi
  done

  notification "$choice"

  # Play the selected local music file using mpv
  mpv --shuffle --vid=no "$file"
}


# Main function for playing online music
play_online_music() {
  choice=$(printf "%s\n" "${!online_music[@]}" | rofi -i -dmenu -config ~/.config/rofi/config-rofi-Beats.rasi -p "Online Music")

  if [ -z "$choice" ]; then
    exit 1
  fi

  link="${online_music[$choice]}"

  notification "$choice"
  
  # Play the selected online music using mpv
  mpv --shuffle --vid=no "$link"
}

# Check if an online music process is running and send a notification, otherwise run the main function
pkill mpv && notify-send -u low -i "$iDIR/music.png" "Online Music stopped" || {

# Prompt the user to choose between local and online music
user_choice=$(printf "Play from Music Folder\nPlay from Online Stations" | rofi -dmenu -config ~/.config/rofi/config-rofi-Beats-menu.rasi -p "Select music source")

  case "$user_choice" in
    "Play from Music Folder")
      play_local_music
      ;;
    "Play from Online Stations")
      play_online_music
      ;;
    *)
      echo "Invalid choice"
      ;;
  esac
}

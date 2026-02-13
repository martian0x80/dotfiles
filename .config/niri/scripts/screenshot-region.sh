#!/bin/bash
grim -g "$(slurp -c '#ff0000ff')" -t ppm - | satty -f - --initial-tool=arrow --copy-command=wl-copy --actions-on-escape="save-to-clipboard,exit" --brush-smooth-history-size=5 --disable-notifications --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png

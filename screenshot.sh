#!/bin/bash

device_id="$1"
mkdir -p screenshots
out_file="screenshots/${device_id}.png"
tmp_file="screenshots/tmp_fullscreen.png"


# full-screen screenshot
screencapture -x "$tmp_file"

# get window position and size from ConnectIG
geometry=$(osascript <<EOF
tell application "System Events"
	tell process "simulator"
		repeat with w in windows
			if name of w contains "CIQ Simulator" then
				set {x, y} to position of w
				set {w, h} to size of w
				return (x as string) & "," & (y as string) & "," & (w as string) & "," & (h as string)
			end if
		end repeat
	end tell
end tell
EOF
)

# if geometry, crop the screenshot
if [[ -n "$geometry" ]]; then
    # scale factor is 2, macOS is reporting the logical value.
    scale=2
	IFS=',' read -r x y w h <<< "$geometry"
    x=$(echo "$x * $scale" | bc | awk '{printf "%d", $0}')
    y=$(echo "$y * $scale" | bc | awk '{printf "%d", $0}')
    w=$(echo "$w * $scale" | bc | awk '{printf "%d", $0}')
    h=$(echo "$h * $scale" | bc | awk '{printf "%d", $0}')
    # crop the bars of teh simulator off
    y=$((y + 60))
    h=$((h - 120))

	echo "window size: x=$x y=$y w=$w h=$h"
	# sips -c "$h" "$w" "$tmp_file" --out "$out_file" >/dev/null
    magick "$tmp_file" -crop "${w}x${h}+${x}+${y}" +repage "$out_file"
	rm "$tmp_file"
else
	echo "Could not find CIQ Simulator window – keeping full screenshot"
	mv "$tmp_file" "$out_file"
fi

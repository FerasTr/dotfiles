#!/usr/bin/env bash
y_margin=32
x_margin=16

# Check if wlogout is already running
if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

# Detect monitor resolution and scaling factor
x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
hypr_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')

left_mgn=$((x_margin * x_mon / hypr_scale))
right_mgn=$((x_margin * x_mon / hypr_scale))
top_mgn=$((y_margin * y_mon / hypr_scale))
bot_mgn=$((y_margin * y_mon / hypr_scale))

echo ${left_mgn}
echo -ne "\n"
echo ${right_mgn}
echo -ne "\n"
echo ${top_mgn}
echo -ne "\n"
echo ${bot_mgn}

wlogout --show-binds --no-span --protocol layer-shell  -b 5 -L ${left_mgn} -R ${right_mgn} -T ${top_mgn} -B ${bot_mgn} &

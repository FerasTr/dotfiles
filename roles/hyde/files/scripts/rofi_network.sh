#!/usr/bin/env bash
rofi_command="rofi -theme $HOME/.config/rofi/network.rasi"

# Get info
IFACE="$(nmcli | grep -i interface | head -n1 | cut -d' ' -f2)"
STATUS="$(nmcli radio wifi)"
_SSID="$(iwgetid -r)"
_LIP="$(nmcli | grep -i server | head -n1 | cut -d' ' -f2)"
_PIP="$(wget --timeout=30 http://ipinfo.io/ip -qO -)"

active=""
urgent=""

if (ping -c 1 archlinux.org || ping -c 1 google.com || ping -c 1 bitbucket.org || ping -c 1 github.com || ping -c 1 sourceforge.net) &>/dev/null; then
	if [[ $STATUS == *"enable"* ]]; then
        if [[ $IFACE == e* ]]; then
            connected="直 Connected To Internet"
        else
            connected="直 Connected To Internet"
        fi
	active="-a 0"
	SSID="$_SSID"
	PIP="$_PIP"
	fi
else
    urgent="-u 0"
    SSID="Disconnected"
    PIP="NA"
    connected="睊 Offline"
fi

# Icons
bmon=" Open Bandwidth Monitor"
launch_cli=" Open Network Manager"
launch="ﯱ Open Connection Editor"

options="$connected\n$bmon\n$launch_cli\n$launch"

# Main
chosen="$(echo -e "$options" | $rofi_command -p "$SSID : $PIP" -dmenu $active $urgent -selected-row 1)"
case $chosen in
    $connected)
		if [[ $STATUS == *"enable"* ]]; then
			nmcli radio wifi off
		else
			nmcli radio wifi on
		fi 
        ;;
    $bmon)
        kitty -e bmon
        ;;
    $launch_cli)
        kitty -e nmtui
        ;;
    $launch)
        nm-connection-editor
        ;;
esac


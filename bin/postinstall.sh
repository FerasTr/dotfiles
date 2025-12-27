#!/bin/bash
#


function powerprofile {
    echo "setting up powerprofile"
# if ls /sys/class/power_supply/BAT* &>/dev/null; then
#   # This computer runs on a battery
#   powerprofilesctl set balanced || true

#   # Enable battery monitoring timer for low battery notifications
#   systemctl --user enable --now omarchy-battery-monitor.timer
# else
#   # This computer runs on power outlet
#   powerprofilesctl set performance || true
# fi
}




function global_theme {
    echo "setting up gnome theme"
# gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
# gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
# gsettings set org.gnome.desktop.interface icon-theme "Yaru-blue"

# sudo gtk-update-icon-cache /usr/share/icons/Yaru
}

function dns {
    echo "setting up dns"
# # https://wiki.archlinux.org/title/Systemd-resolved
# echo "Symlink resolved stub-resolv to /etc/resolv.conf"

# sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
}

function firewall {
    echo "setting up firewall"
    # Allow nothing in, everything out
# sudo ufw default deny incoming
# sudo ufw default allow outgoing

# # Allow ports for LocalSend
# sudo ufw allow 53317/udp
# sudo ufw allow 53317/tcp

# # Allow Docker containers to use DNS on host
# sudo ufw allow in proto udp from 172.16.0.0/12 to 172.17.0.1 port 53 comment 'allow-docker-dns'

# # Turn on the firewall
# sudo ufw --force enable

# # Enable UFW systemd service to start on boot
# sudo systemctl enable ufw

# # Turn on Docker protections
# sudo ufw-docker install
# sudo ufw reload
}


function application_configuration {
    echo "setting up application specific configuration"

    # tobi-try
    echo "configuring try..."
    eval "$(try init $HOME/workspace/experiments)"

    # github-cli
    echo "configuring github cli..."

    # starship
    export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
}

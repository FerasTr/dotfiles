#!/usr/bin/env bash
rofi -dmenu\
     -password\
     -i\
     -no-fixed-num-lines\
     -p "User Password: "\
     -theme $HOME/.config/rofi/askpass.rasi

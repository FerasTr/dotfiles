#!/usr/bin/env bash
export SUDO_ASKPASS=rofi_askpass.sh

## execute the application
sudo -A $1

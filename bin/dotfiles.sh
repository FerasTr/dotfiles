#!/bin/bash

DOTFILES_LOG="$HOME/.dotfiles.log"

set -e

# Paths
VAULT_SECRET="$HOME/.ansible-vault/vault.secret"
DOTFILES_DIR="$HOME/.dotfiles"
# SSH_DIR="$HOME/.ssh"

# _header colorize the given argument with spacing
function _task {
  TASK=$1
  echo "$TASK"
}

# _cmd performs commands with error checking
function _cmd {
  #create log if it doesn't exist
  if ! [[ -f $DOTFILES_LOG ]]; then
    touch $DOTFILES_LOG
  fi
  # empty conduro.log
  >$DOTFILES_LOG
  # hide stdout, on error we print and exit
  if eval "$1" 1>/dev/null 2>$DOTFILES_LOG; then
    return 0 # success
  fi
  # read error from log and add spacing
  echo "[X] $TASK"
  while read line; do
    printf "      ${line}\n"
  done <$DOTFILES_LOG
  echo
  # exit installation
  exit 1
}

function _update_pkgs {
  _task "upgrading packages"
  _cmd "sudo pacman -Syu --noconfirm"
}

function _install_ansible {
  if ! [ -x "$(command -v ansible)" ]; then
    _task "Installing Ansible"
    _cmd "sudo pacman -S --noconfirm ansible"
  fi
}

function _install_python_pkgs {
  if ! pacman -Q python >/dev/null 2>&1; then
    _task "Installing Python"
    _cmd "sudo pacman -S --noconfirm python"
  fi
  if ! pacman -Q python-pip >/dev/null 2>&1; then
    _task "Installing Pip"
    _cmd "sudo pacman -S --noconfirm python-pip"
  fi
  if ! pip list | grep watchdog >/dev/null 2>&1; then
    _task "Installing Python3 Watchdog"
    _cmd "sudo pacman -S --noconfirm python-watchdog"
  fi

  if ! pip list | grep argcomplete >/dev/null 2>&1; then
    _task "Installing Python argcomplete"
    _cmd "sudo pacman -S --noconfirm python-argcomplete"
  fi
}

function _install_yay {
  if ! command -v yay >/dev/null; then
    _task "installing yay"
    tmp_dir=$(mktemp -d)
    function finish { rm -rf "$tmp_dir"; } # clean up after yourself...
    trap finish EXIT                       # ...no matter how you exist

    git clone https://aur.archlinux.org/yay.git "$tmp_dir"
    pushd "$tmp_dir"
    makepkg -sri --noconfirm --needed
    popd

    if ! command -v yay >/dev/null; then
      >&2 echo "yay failed to install"
      exit 1
    else
      _task "Setting up yay"
      _cmd "yay -Y --gendb --noconfirm"
    fi
  fi
}

function update_ansible_galaxy() {
  local os=$1
  local os_requirements=""
  _task "Updating Ansible Galaxy"
  if [ -f "$DOTFILES_DIR/requirements/$os.yml" ]; then
    _task "Updating Ansible Galaxy with OS Config: $os"
    os_requirements="$DOTFILES_DIR/requirements/$os.yml"
  fi
  _cmd "ansible-galaxy install -r $DOTFILES_DIR/requirements/common.yml $os_requirements"
}

function run_playbook() {
  local extra_vars=""
  if [ -n "$1" ]; then
      extra_vars="$1"
  fi
  _task "Running playbook"
  #FIXME: support passing arguments to ansible-playbook
  # if [[ -f $VAULT_SECRET ]]; then
  #   ansible-playbook --vault-password-file $VAULT_SECRET "$DOTFILES_DIR/main.yml" "$extra_vars"
  # else
  #   ansible-playbook "$DOTFILES_DIR/main.yml" "$extra_vars"
  # fi
  if [[ -f $VAULT_SECRET ]]; then
    ansible-playbook --vault-password-file $VAULT_SECRET "$DOTFILES_DIR/main.yml"
  else
    ansible-playbook "$DOTFILES_DIR/main.yml"
  fi
}

function pull_dotfiles_repo {
  # TODO: implement a task that checks for updates locally then pushes to remote
  if ! [[ -d "$DOTFILES_DIR" ]]; then
    _task "Cloning repository"
    _cmd "git clone --quiet https://github.com/FerasTr/dotfiles.git $DOTFILES_DIR"
  else
    _task "Updating repository"
    _cmd "git -C $DOTFILES_DIR pull --quiet"
  fi
}

function _cleanup() {
  _task "Remove logs file"
  _cmd "rm $DOTFILES_LOG"
}

function arch_setup() {

  _update_pkgs

  _install_ansible

  _install_python_pkgs

  _install_yay
}

function _install() {
  source /etc/os-release
  _task "Loading Setup for detected OS: $ID"

  case $ID in
  arch)
    arch_setup
    ;;
  *)
    _task "Unsupported OS"
    _cmd "echo 'Unsupported OS'"
    ;;
  esac

  pull_dotfiles_repo

  pushd "$DOTFILES_DIR" 2>&1 >/dev/null

  update_ansible_galaxy $ID

  # FIXME: arguments for ansible-playbook
  # run_playbook $1
  run_playbook $1

  popd 2>&1 >/dev/null

}

function main() {
  if [ $# -eq 0 ]; then
    echo "No arguments provided. Usage: dotfiles.sh [command] [options]"
    exit 1
  fi

  case "$1" in
  clean)
    _cleanup
    exit 0
    ;;

  install)
    _install "$2"
    exit 0
    ;;

  *)
    echo "Unkown command: $1"
    echo "Usage: $0 [clean] [install] (options)"
    exit 1
    ;;

  esac
}

main "$@"

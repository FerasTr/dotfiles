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

function _clear_task {
  TASK=""
}

function _task_done {
  echo "[✓] $TASK"
  _clear_task
}

function arch_setup() {
  if ! [ -x "$(command -v ansible)" ]; then
    _task "Installing Ansible"
    _cmd "sudo pacman -Sy --noconfirm"
    _cmd "sudo pacman -S --noconfirm ansible"
    _cmd "sudo pacman -S --noconfirm python-argcomplete"
    # _cmd "sudo activate-global-python-argcomplete3"
  fi
  if ! pacman -Q python3 >/dev/null 2>&1; then
    _task "Installing Python3"
    _cmd "sudo pacman -S --noconfirm python3"
  fi
  if ! pacman -Q python-pip >/dev/null 2>&1; then
    _task "Installing Python3 Pip"
    _cmd "sudo pacman -S --noconfirm python-pip"
  fi
  if ! pip3 list | grep watchdog >/dev/null 2>&1; then
    _task "Installing Python3 Watchdog"
    _cmd "sudo pacman -S --noconfirm python-watchdog"
  fi

  if ! pacman -Q openssh >/dev/null 2>&1; then
    _task "Installing OpenSSH"
    _cmd "sudo pacman -S --noconfirm openssh"
  fi

  _task "Setting Locale"
  _cmd "sudo localectl set-locale LANG=en_US.UTF-8"

  _task "Installing yay"
  _cmd "sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin && pushd /tmp/yay-bin && makepkg -si && popd"

  _task "Setting up yay"
  _cmd "yay -Y --gendb"
}

update_ansible_galaxy() {
  local os=$1
  local os_requirements=""
  _task "Updating Ansible Galaxy"
  if [ -f "$DOTFILES_DIR/requirements/$os.yml" ]; then
    _task "Updating Ansible Galaxy with OS Config: $os"
    os_requirements="$DOTFILES_DIR/requirements/$os.yml"
  fi
  _cmd "ansible-galaxy install -r $DOTFILES_DIR/requirements/common.yml $os_requirements"
}

_cleanup() {
  _task "Remove logs file"
  _cmd "rm $DOTFILES_LOG"
}

_install() {
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

  # TODO: generate keys to use with ssh and git
  # if ! [[ -f "$SSH_DIR/authorized_keys" ]]; then
  #   _task "Generating SSH keys"
  #   _cmd "mkdir -p $SSH_DIR"
  #   _cmd "chmod 700 $SSH_DIR"
  #   _cmd "ssh-keygen -b 4096 -t rsa -f $SSH_DIR/id_rsa -N '' -C $USER@$HOSTNAME"
  #   _cmd "cat $SSH_DIR/id_rsa.pub >> $SSH_DIR/authorized_keys"
  # fi

  # TODO: implement a task that checks for updates locally then pushes to remote
  if ! [[ -d "$DOTFILES_DIR" ]]; then
    _task "Cloning repository"
    _cmd "git clone --quiet https://github.com/FerasTr/dotfiles.git $DOTFILES_DIR"
  else
    _task "Updating repository"
    _cmd "git -C $DOTFILES_DIR pull --quiet"
  fi

  pushd "$DOTFILES_DIR" 2>&1 >/dev/null
  update_ansible_galaxy $ID

  _task "Running playbook"
  _task_done
  if [[ -f $VAULT_SECRET ]]; then
    ansible-playbook --vault-password-file $VAULT_SECRET "$DOTFILES_DIR/main.yml" "$@"
  else
    ansible-playbook "$DOTFILES_DIR/main.yml" "$@"
  fi

  popd 2>&1 >/dev/null
}

main() {
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
    _install "$@"
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

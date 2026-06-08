#!/usr/bin/env bash
# Shared distro detection — source this file, do not execute it.
# Sets: _distro, _version, PKG_COL, install_cmd()

_distro=$(grep '^ID=' /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"')
_version=$(grep '^VERSION_ID=' /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"')

case "$_distro" in
  ubuntu|debian|raspbian)
    PKG_COL=2
    install_cmd() { sudo apt-get install -y "$@"; }
    ;;
  arch|manjaro|endeavouros)
    PKG_COL=3
    install_cmd() { sudo pacman -S --noconfirm "$@"; }
    ;;
  fedora)
    PKG_COL=4
    if [ "${_version:-0}" -gt 21 ] 2>/dev/null; then
      install_cmd() { sudo dnf install -y "$@"; }
    else
      install_cmd() { sudo yum install -y "$@"; }
    fi
    ;;
  *)
    fail "unsupported distro: ${_distro:-unknown}"
    ;;
esac

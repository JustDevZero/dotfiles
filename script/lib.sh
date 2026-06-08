#!/usr/bin/env bash
# Shared helpers for dotfiles scripts — source this file, do not execute it.

info()    { printf '  [ \033[00;34m..\033[0m ] %s\n' "$1"; }
success() { printf '  [ \033[00;32mOK\033[0m ] %s\n' "$1"; }
warn()    { printf '  [ \033[0;33m!!\033[0m ] %s\n' "$1"; }
fail()    { printf '  [\033[0;31mFAIL\033[0m] %s\n' "$1"; exit 1; }

#!/usr/bin/env bash
set -euo pipefail

echo "==> Instalando yay..."

if ! command -v yay &>/dev/null; then
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
fi

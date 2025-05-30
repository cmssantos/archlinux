#!/usr/bin/env bash
set -euo pipefail

echo "==> Instalando microcódigo..."

if lscpu | grep -qi intel; then
  sudo pacman -S --needed --noconfirm intel-ucode
elif lscpu | grep -qi amd; then
  sudo pacman -S --needed --noconfirm amd-ucode
fi

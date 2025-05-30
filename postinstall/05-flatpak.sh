#!/usr/bin/env bash
set -euo pipefail

echo "==> Instalando Flatpak e adicionando Flathub..."
sudo pacman -S --needed --noconfirm flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

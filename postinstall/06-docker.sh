#!/usr/bin/env bash
set -euo pipefail

USERNAME="csantos"

echo "==> Instalando Docker..."
sudo pacman -S --needed --noconfirm docker docker-compose
sudo systemctl enable --now docker
sudo usermod -aG docker "$USERNAME"

#!/usr/bin/env bash
set -euo pipefail

echo "==> Atualizando sistema e base do yay..."
sudo pacman -Syu --noconfirm
yay -Syu --noconfirm

echo "==> Instalando fontes via yay..."

yay -S --needed --noconfirm \
  ttf-fira-code \
  ttf-jetbrains-mono \
  ttf-jetbrains-mono-nerd \
  ttf-ms-fonts \
  ttf-vista-fonts \
  ttf-cascadia-code \
  ttf-roboto \
  ttf-segoe-ui \
  ttf-dejavu \
  noto-fonts \
  noto-fonts-emoji \
  ttf-hack  \
  ttf-sourcecodepro

echo "==> Atualizando cache de fontes..."
sudo fc-cache -f

echo "==> Fontes instaladas com sucesso."

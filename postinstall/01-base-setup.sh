#!/usr/bin/env bash
set -euo pipefail

USERNAME="csantos"

echo "==> Atualizando pacotes..."
sudo pacman -Syu --noconfirm

echo "==> Instalando pacotes base..."
sudo pacman -S --needed --noconfirm \
  base-devel go git curl wget zip unzip tar zsh reflector keychain fuse ntfs-3g xclip stow

if ! grep -q "^%wheel ALL=(ALL) ALL" /etc/sudoers; then
  echo "==> Habilitando sudo para wheel..."
  sudo sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
fi

echo "==> Configurando mirrors para o Brasil..."
sudo reflector --country Brazil --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

#!/usr/bin/env bash
set -euo pipefail

echo "==> Atualizando sistema..."
sudo pacman -Syu --noconfirm

# 1. Core GNOME (Shell e básicos)
echo "==> Instalando GNOME Core..."
sudo pacman -S --noconfirm \
gnome-shell \
gnome-session \
gnome-keyring \
gnome-control-center \
gnome-settings-daemon \
xdg-user-dirs-gtk \
adwaita-icon-theme \
gnome-themes-extra \
gnome-backgrounds \
gnome-system-monitor

# 2. GNOME apps essenciais
echo "==> Instalando aplicativos básicos GNOME..."
sudo pacman -S --noconfirm \
gnome-console \
gnome-software \
nautilus \
gnome-text-editor \
loupe

# 3. GNOME Extras (opcional, apps adicionais)
echo "==> Instalando GNOME Extras (opcional)..."
sudo pacman -S --noconfirm gnome-calculator gnome-logs gnome-tweaks

# 4. Gerenciador de login GDM (Wayland ready)
echo "==> Instalando GDM..."
sudo pacman -S --noconfirm gdm

echo "==> Habilitando e iniciando GDM..."
sudo systemctl enable gdm.service
sudo systemctl start gdm.service

# 5. Impressão e digitalização
echo "==> Instalando suporte a impressão e digitalização..."
sudo pacman -S --noconfirm cups system-config-printer

echo "==> Habilitando CUPS..."
sudo systemctl enable --now cups.service

echo "==> GNOME modular instalado. Reinicie para iniciar com Wayland."

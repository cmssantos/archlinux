#!/usr/bin/env bash
set -euo pipefail

echo "==> Instalando UFW..."
sudo pacman -S --noconfirm ufw

echo "==> Ativando e configurando UFW..."

sudo systemctl enable --now ufw

echo "==> Permitindo SSH para evitar bloqueio..."
sudo ufw allow ssh

echo "==> Definindo regras padrão..."
sudo ufw default deny incoming
sudo ufw default allow outgoing

echo "==> Ativando firewall..."
sudo ufw --force enable

echo "==> Status do UFW:"
sudo ufw status verbose

echo "==> Firewall configurado com sucesso."

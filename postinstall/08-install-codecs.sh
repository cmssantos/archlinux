#!/usr/bin/env bash
set -euo pipefail

echo "==> Atualizando sistema..."
sudo pacman -Syu --noconfirm

echo "==> Instalando codecs e plugins GStreamer e FFmpeg..."
sudo pacman -S --needed --noconfirm \
  gstreamer \
  gst-libav \
  gst-plugins-base \
  gst-plugins-good \
  gst-plugins-ugly \
  gst-plugins-bad \
  ffmpeg

echo "==> Instalando PipeWire e PulseAudio replacement..."
sudo pacman -S --needed --noconfirm pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber

echo "==> Habilitando serviços PipeWire para o usuário..."

systemctl --user enable pipewire pipewire-pulse wireplumber
systemctl --user start pipewire pipewire-pulse wireplumber

echo "==> Configuração concluída."

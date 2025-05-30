#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="$HOME/.config/pipewire"
MEDIA_SESSION_DIR="$CONFIG_DIR/media-session.d"

echo "==> Criando pastas de configuração..."
mkdir -p "$MEDIA_SESSION_DIR"

echo "==> Copiando arquivos base do Pipewire para override..."
cp /usr/share/pipewire/pipewire.conf "$CONFIG_DIR/"
cp /usr/share/pipewire/media-session.d/default.conf "$MEDIA_SESSION_DIR/"

echo "==> Aplicando ajustes de baixa latência em pipewire.conf..."
cat > "$CONFIG_DIR/pipewire.conf" <<'EOF'
context.properties = {
    default.clock.quantum        = 256
    default.clock.min-quantum    = 64
    default.clock.max-quantum    = 2048
    default.clock.min-quantum-time = 4000/48000
    default.clock.max-quantum-time = 240000/48000
    default.clock.rate           = 48000
}
EOF

echo "==> Aplicando ajustes em media-session.d/default.conf..."
cat > "$MEDIA_SESSION_DIR/default.conf" <<'EOF'
context.properties = {
  default.clock.rate          = 48000
  default.clock.allowed-rates = [ 44100 48000 ]
  default.clock.quantum       = 256
  default.clock.min-quantum   = 64
  default.clock.max-quantum   = 2048
}
EOF

echo "==> Reiniciando serviços Pipewire..."
systemctl --user daemon-reload
systemctl --user restart pipewire pipewire-pulse

echo "==> Configuração Pipewire aplicada com sucesso!"

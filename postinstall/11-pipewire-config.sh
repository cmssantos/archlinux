#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="$HOME/.config/pipewire"

echo "==> Criando pasta de configuração..."
mkdir -p "$CONFIG_DIR"

echo "==> Copiando pipewire.conf base para override..."
cp /usr/share/pipewire/pipewire.conf "$CONFIG_DIR/"

echo "==> Aplicando ajustes de baixa latência em pipewire.conf..."
cat > "$CONFIG_DIR/pipewire.conf" <<'EOF'
context.properties = {
    default.clock.rate          = 48000
    default.clock.quantum       = 256
    default.clock.min-quantum   = 64
    default.clock.max-quantum   = 2048
}
EOF

echo "==> Reiniciando serviços Pipewire..."
systemctl --user daemon-reexec
systemctl --user restart pipewire pipewire-pulse wireplumber

echo "==> Configuração Pipewire aplicada com sucesso!"

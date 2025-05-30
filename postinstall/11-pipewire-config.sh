#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="$HOME/.config/pipewire"
CONF_D_DIR="$CONFIG_DIR/pipewire.conf.d"

echo "==> Criando pastas de configuração..."
mkdir -p "$CONF_D_DIR"

echo "==> Criando arquivo de configuração de clock de baixa latência..."
cat > "$CONF_D_DIR/00-clock.conf" <<EOF
context.properties = {
    default.clock.rate          = 48000
    default.clock.quantum       = 256
    default.clock.min-quantum   = 64
    default.clock.max-quantum   = 2048
}
EOF

echo "==> Reiniciando serviços PipeWire..."
systemctl --user daemon-reexec
systemctl --user restart pipewire pipewire-pulse wireplumber

echo "==> Configuração PipeWire aplicada com sucesso!"

#!/usr/bin/env bash
set -euo pipefail

REMOTE_NAME="onedrive"
MOUNT_DIR="$HOME/OneDrive"
SERVICE_FILE="$HOME/.config/systemd/user/rclone-${REMOTE_NAME}.service"

echo "==> Instalando rclone..."
yay -S --noconfirm rclone

echo "==> Criando diretório de montagem em $MOUNT_DIR..."
mkdir -p "$MOUNT_DIR"

echo "==> Instruções para configurar o remote '$REMOTE_NAME'..."
echo "    Execute: rclone config"
echo "    - Escolha 'n' para novo remote"
echo "    - Nome: $REMOTE_NAME"
echo "    - Tipo: onedrive"
echo "    - Autentique via navegador"
echo "    - Salve e saia"
read -p "Pressione Enter após concluir 'rclone config'..."

echo "==> Criando serviço systemd user para montagem automática..."
mkdir -p "$(dirname "$SERVICE_FILE")"

cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Mount Microsoft OneDrive (rclone)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/rclone mount $REMOTE_NAME: $MOUNT_DIR \\
  --vfs-cache-mode full \\
  --vfs-cache-max-size 10G \\
  --vfs-cache-max-age 12h \\
  --poll-interval 15s \\
  --dir-cache-time 72h \\
  --buffer-size 16M \\
  --allow-other \\
  --syslog
ExecStop=/usr/bin/fusermount -u $MOUNT_DIR
Restart=on-failure
RestartSec=10

[Install]
WantedBy=default.target
EOF

echo "==> Ativando serviço de montagem..."
systemctl --user daemon-reload
systemctl --user enable --now rclone-${REMOTE_NAME}

echo "==> Configuração concluída. OneDrive estará acessível em $MOUNT_DIR."
echo "==> Verifique o status do serviço com:"
echo "    systemctl --user status rclone-${REMOTE_NAME}"
echo "==> Para desmontar manualmente, use:"
echo "    fusermount -u $MOUNT_DIR"
echo "==> Configuração concluída. OneDrive montado em $MOUNT_DIR."
# Note: Ensure you have 'fuse' installed for rclone mount to work.


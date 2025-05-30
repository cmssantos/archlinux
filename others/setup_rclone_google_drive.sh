#!/usr/bin/env bash
set -euo pipefail

REMOTE_NAME="gdrive"
MOUNT_DIR="$HOME/GoogleDrive"
SERVICE_FILE="$HOME/.config/systemd/user/rclone-gdrive.service"

echo "==> Instalando rclone..."
yay -S --noconfirm rclone

echo "==> Criando diretório de montagem em $MOUNT_DIR..."
mkdir -p "$MOUNT_DIR"

echo "==> Instruções para configurar o remote 'gdrive'..."
echo "    Execute: rclone config"
echo "    - Escolha 'n' para novo remote"
echo "    - Nome: $REMOTE_NAME"
echo "    - Tipo: drive"
echo "    - Autentique via navegador"
echo "    - Salve e saia"
read -p "Pressione Enter após concluir 'rclone config'..."

echo "==> Criando serviço systemd user para montagem automática..."
mkdir -p "$(dirname "$SERVICE_FILE")"

cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Mount Google Drive (rclone)
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/rclone mount $REMOTE_NAME: \$HOME/GoogleDrive \
  --vfs-cache-mode full \
  --vfs-cache-max-size 10G \
  --vfs-cache-max-age 12h \
  --poll-interval 15s \
  --dir-cache-time 72h \
  --drive-use-trash \
  --buffer-size 16M \
  --allow-other

ExecStop=/bin/fusermount -u \$HOME/GoogleDrive
Restart=on-failure

[Install]
WantedBy=default.target
EOF

echo "==> Ativando serviço de montagem..."
systemctl --user daemon-reexec
systemctl --user enable --now rclone-gdrive

echo "==> Montagem automática configurada. Google Drive estará acessível em $MOUNT_DIR."

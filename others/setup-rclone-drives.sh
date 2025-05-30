#!/usr/bin/env bash

set -euo pipefail

echo "🔧 Verificando se rclone está instalado..."
if ! command -v rclone &> /dev/null; then
  echo "❌ rclone não encontrado. Instale com:"
  echo "    sudo pacman -S rclone"
  exit 1
fi

echo "📁 Criando diretórios necessários..."
mkdir -p ~/GoogleDrive ~/OneDrive ~/.cache/rclone ~/.config/systemd/user

configure_remote_if_missing() {
  local name=$1
  local type=$2

  if ! rclone listremotes | grep -q "^${name}:"; then
    echo "⚠️ Remote '${name}' não encontrado. Iniciando configuração..."

    rclone config create "$name" "$type" \
      config_is_local=false \
      --auto-confirm

    echo "🌐 Abrindo navegador para autenticação..."
    rclone authorize "$type"
  fi
}

echo "🔌 Verificando/configurando remotes..."
configure_remote_if_missing "gdrive" "drive"
configure_remote_if_missing "onedrive" "onedrive"

echo "📦 Criando serviço: rclone-gdrive.service"
cat > ~/.config/systemd/user/rclone-gdrive.service <<EOF
[Unit]
Description=Mount Google Drive (rclone)
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/rclone mount gdrive: %h/GoogleDrive \\
    --config %h/.config/rclone/rclone.conf \\
    --vfs-cache-mode full \\
    --allow-other \\
    --dir-cache-time 72h \\
    --poll-interval 15s \\
    --log-level INFO \\
    --log-file %h/.cache/rclone/rclone-mount-gdrive.log
ExecStop=/bin/fusermount3 -u %h/GoogleDrive
Restart=on-failure
RestartSec=10
TimeoutStopSec=20

[Install]
WantedBy=default.target
EOF

echo "📦 Criando serviço: rclone-onedrive.service"
cat > ~/.config/systemd/user/rclone-onedrive.service <<EOF
[Unit]
Description=Mount OneDrive (rclone)
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/rclone mount onedrive: %h/OneDrive \\
    --config %h/.config/rclone/rclone.conf \\
    --vfs-cache-mode full \\
    --allow-other \\
    --dir-cache-time 72h \\
    --poll-interval 15s \\
    --log-level INFO \\
    --log-file %h/.cache/rclone/rclone-mount-onedrive.log
ExecStop=/bin/fusermount3 -u %h/OneDrive
Restart=on-failure
RestartSec=10
TimeoutStopSec=20

[Install]
WantedBy=default.target
EOF

echo "🔄 Recarregando systemd (user)"
systemctl --user daemon-reexec
systemctl --user daemon-reload

echo "✅ Habilitando e iniciando serviços"
systemctl --user enable --now rclone-gdrive.service
systemctl --user enable --now rclone-onedrive.service

echo -e "\n🎉 Montagens ativadas!"
echo "📁 Google Drive -> ~/GoogleDrive"
echo "📁 OneDrive     -> ~/OneDrive"
echo "ℹ️ Logs em ~/.cache/rclone/"

echo -e "\n📎 Para checar status:"
echo "    systemctl --user status rclone-gdrive.service"
echo "    systemctl --user status rclone-onedrive.service"

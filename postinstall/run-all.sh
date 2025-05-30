#!/usr/bin/env bash
set -euo pipefail

SCRIPTS=(
  "01-base-setup.sh"
  "02-microcode.sh"
  "03-yay-install.sh"
  "04-zsh-setup.sh"
  "05-flatpak.sh"
  "06-docker.sh"
  "07-install-asdf.sh"
  "08-install-codecs.sh"
  "09-install-fonts.sh"
  "10-setup-firewall.sh"
)

for script in "${SCRIPTS[@]}"; do
  echo "==> Executando $script ..."
  ./"$script"
done

echo "==> Todos os scripts executados com sucesso."

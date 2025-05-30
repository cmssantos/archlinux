#!/usr/bin/env bash
set -euo pipefail

USERNAME="csantos"

echo "==> Configurando Zsh e Oh My Zsh..."

if [[ "$SHELL" != "/bin/zsh" ]]; then
  chsh -s /bin/zsh "$USERNAME"
fi

if [ ! -d "/home/$USERNAME/.oh-my-zsh" ]; then
  sudo -u "$USERNAME" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

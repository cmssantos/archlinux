#!/usr/bin/env bash
set -euo pipefail

USERNAME="csantos"
ZSHRC_PATH="/home/$USERNAME/.zshrc"
ASDF_DIR="${ASDF_DATA_DIR:-/home/$USERNAME/.asdf}"

echo "==> Instalando asdf via yay..."
yay -S --needed --noconfirm asdf-vm

echo "==> Criando diretório de completions..."
mkdir -p "${ASDF_DIR}/completions"
asdf completion zsh > "${ASDF_DIR}/completions/_asdf"

echo "==> Atualizando .zshrc de $USERNAME..."

ASDF_CONFIG="
# >>> ASDF CONFIG START >>>
export PATH=\"\${ASDF_DATA_DIR:-\$HOME/.asdf}/shims:\$PATH\"
# export ASDF_DATA_DIR=\"$ASDF_DIR\"  # Descomente se quiser usar um diretório customizado

. /opt/asdf-vm/asdf.sh

# Zsh completions
fpath=(\${ASDF_DATA_DIR:-\$HOME/.asdf}/completions \$fpath)
autoload -Uz compinit && compinit
# <<< ASDF CONFIG END <<<
"

if ! grep -q 'ASDF CONFIG START' "$ZSHRC_PATH"; then
  echo "$ASDF_CONFIG" >> "$ZSHRC_PATH"
fi

echo "==> Instalando plugins do dotnet e nodejs..."

asdf plugin add dotnet || echo "dotnet plugin já instalado"
asdf plugin add nodejs || echo "nodejs plugin já instalado"

echo "==> Importando chave de certificação do Node.js para asdf (necessário para alguns sistemas)..."
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring

echo "==> Instalando versões LTS do dotnet e nodejs..."

DOTNET_LTS=$(asdf list-all dotnet | grep -E '^[0-9]+\.[0-9]+(\.[0-9]+)?$' | sort -rV | head -n 1)
NODEJS_LTS=$(asdf list-all nodejs | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | grep -E '^(v14|v16|v18|v20)' | sort -rV | head -n 1)

asdf install dotnet "$DOTNET_LTS"
asdf global dotnet "$DOTNET_LTS"

asdf install nodejs "$NODEJS_LTS"
asdf global nodejs "$NODEJS_LTS"

echo "==> asdf configurado com dotnet $DOTNET_LTS e nodejs $NODEJS_LTS (LTS)."

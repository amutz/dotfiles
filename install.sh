#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$(uname -m)" in
  x86_64) NVIM_ARCH="x86_64" ;;
  aarch64) NVIM_ARCH="arm64" ;;
  *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  SUDO="sudo"
fi

echo "Installing neovim (linux-${NVIM_ARCH})..."
curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz" \
  | $SUDO tar -xz -C /opt
$SUDO ln -sf "/opt/nvim-linux-${NVIM_ARCH}/bin/nvim" /usr/local/bin/nvim

# ripgrep/fd for pickers and grep; unzip for mason-installed LSP servers
if command -v apt-get >/dev/null; then
  $SUDO apt-get update -qq
  $SUDO apt-get install -y -qq ripgrep fd-find unzip
fi

echo "Linking nvim config..."
mkdir -p ~/.config
if [ -e ~/.config/nvim ] && [ ! -L ~/.config/nvim ]; then
  mv ~/.config/nvim ~/.config/nvim.bak."$(date +%s)"
  echo "Existing ~/.config/nvim moved aside to ~/.config/nvim.bak.*"
fi
ln -sfn "$DOTFILES_DIR/nvim" ~/.config/nvim

echo "Pre-installing plugins from lazy-lock.json..."
nvim --headless "+Lazy! restore" +qa || echo "Plugin restore failed; they will install on first launch."
# LSP servers (mason) and treesitter parsers install on first interactive
# launch — expect a busy minute the first time nvim is opened.

echo "Done. nvim $(nvim --version | head -1) installed."

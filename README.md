# dotfiles

Personal dev environment setup, used to bring neovim into devcontainers
without touching shared project config.

`install.sh` installs the latest neovim release, ripgrep/fd, symlinks
`nvim/` to `~/.config/nvim`, and restores plugins from `lazy-lock.json`.

## Usage with the devcontainer CLI

```bash
devcontainer up --workspace-folder . \
  --dotfiles-repository https://github.com/amutz/dotfiles.git
```

The CLI clones this repo to `~/dotfiles` in the container and runs
`install.sh` automatically on container creation.

## Usage with VS Code / Codespaces

- VS Code: set `"dotfiles.repository": "amutz/dotfiles"` in user settings.
- Codespaces: GitHub Settings → Codespaces → "Automatically install dotfiles".

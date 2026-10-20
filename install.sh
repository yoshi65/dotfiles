#!/bin/bash
set -euo pipefail

# Parse command line arguments
FORCE=false
while [[ $# -gt 0 ]]; do
  case $1 in
    -f|--force) FORCE=true; shift ;;
    -h|--help)
      echo "Usage: $0 [-f|--force] [-h|--help]"
      echo "  -f, --force  Skip confirmation prompt"
      echo "  -h, --help   Show this help message"
      exit 0 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

# Get absolute path to dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Function to backup existing files
backup_file() {
  local target="$1"
  if [[ -e "$target" && ! -L "$target" ]]; then
    mkdir -p "$BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/"
    echo "💾 Backed up: $target -> $BACKUP_DIR/"
  fi
}

# Function to create symlink safely
create_symlink() {
  local source="$1"
  local target="$2"

  # Skip if already correctly linked
  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    echo "✓ Already linked: $target"
    return 0
  fi

  backup_file "$target"

  # Create parent directory if needed
  mkdir -p "$(dirname "$target")"

  if ln -sfn "$source" "$target"; then
    echo "✓ Linked: $target -> $source"
  else
    echo "✗ Failed to link: $target"
    return 1
  fi
}

# Confirmation prompt (unless --force is used)
if [[ "$FORCE" == false && -t 0 ]]; then
  echo "This will create symlinks for dotfiles in your home directory."
  echo "Existing files will be backed up to $BACKUP_DIR"
  read -p "Continue? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
  fi
fi

echo "🚀 Installing dotfiles from $DOTFILES_DIR"

# Root-level entries to link. Listed explicitly rather than globbed: the repository
# root also holds files that must never reach $HOME (.mcp.json, .pre-commit-config.yaml,
# .claude/, .omc/ ...), and a glob with an exclusion list quietly links each new one.
HOME_ENTRIES=(
    ".tigrc"
    ".tmux"
    ".tmux.conf"
    ".vim"
    ".vimrc"
    ".zshenv"
    ".zshrc"
)

# Entries under .config, linked one by one so the rest of ~/.config stays untouched.
CONFIG_ENTRIES=(
    "flake8"
    "ghostty"
    "git"
    "nvim"
    "pycodestyle"
    "starship.toml"
    "template"
    "yazi"
)

# A Linux host may own ~/.zshrc and rewrite it on every start. Linking over it would
# lose either side, so ours becomes ~/.zshrc.personal and the host file sources it.
host_owns_zshrc() {
  [[ "$OSTYPE" == linux* ]]
}

hook_zshrc() {
  # Appends from the host would land in this repository through a link into it.
  if [[ -L "$HOME/.zshrc" && "$(readlink "$HOME/.zshrc")" == "$DOTFILES_DIR/.zshrc" ]]; then
    rm "$HOME/.zshrc"
  fi
  touch "$HOME/.zshrc"
  if grep -qF '.zshrc.personal' "$HOME/.zshrc"; then
    echo "✓ Already hooked: ~/.zshrc"
  else
    printf '\n# personal layer (yoshi65/dotfiles)\n[[ -f ~/.zshrc.personal ]] && source ~/.zshrc.personal\n' >> "$HOME/.zshrc"
    echo "✓ Hooked: ~/.zshrc sources ~/.zshrc.personal"
  fi
}

echo "🏠 Installing root-level dotfiles..."
for entry in "${HOME_ENTRIES[@]}"; do
    if [[ "$entry" == ".zshrc" ]] && host_owns_zshrc; then
        create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc.personal"
        hook_zshrc
    elif [[ -e "$DOTFILES_DIR/$entry" ]]; then
        create_symlink "$DOTFILES_DIR/$entry" "$HOME/$entry"
    fi
done

echo "📊 Installing Claude Code statusline scripts..."
for script in statusline-simple.sh statusline.py; do
    create_symlink "$DOTFILES_DIR/claude/$script" "$HOME/.claude/$script"
done

echo "📁 Installing .config applications..."
if [[ -d "$DOTFILES_DIR/.config" ]]; then
    mkdir -p "$HOME/.config"

    for entry in "${CONFIG_ENTRIES[@]}"; do
        if [[ -e "$DOTFILES_DIR/.config/$entry" ]]; then
            create_symlink "$DOTFILES_DIR/.config/$entry" "$HOME/.config/$entry"
        fi
    done

    # Everything tracked under .config is meant for ~/.config, so anything git knows
    # about but the list above misses is drift, not intent. starship.toml, ghostty/
    # and yazi/ sat tracked-but-unlinked this way until it was noticed by hand.
    if command -v git > /dev/null 2>&1 &&
        git -C "$DOTFILES_DIR" rev-parse --git-dir > /dev/null 2>&1; then
        listed=" ${CONFIG_ENTRIES[*]} "
        while read -r entry; do
            if [[ -n "$entry" ]] && [[ "$listed" != *" $entry "* ]]; then
                echo "⚠️  Tracked but not linked: .config/$entry (add it to CONFIG_ENTRIES)"
            fi
        done < <(git -C "$DOTFILES_DIR" ls-files -- .config | cut -d/ -f2 | sort -u)
    fi
fi

# Claude Code plugins to install on Linux, as "<marketplace repo>|<plugin>@<marketplace>".
CLAUDE_PLUGINS=(
    "DietrichGebert/ponytail|ponytail@ponytail"
)

# Linux hosts start without the tools and plugins a workstation already has. Each step
# warns instead of aborting, so one missing prerequisite does not block the rest.
setup_linux() {
  local brew=""
  if command -v brew > /dev/null 2>&1; then
    brew="$(command -v brew)"
  elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    brew=/home/linuxbrew/.linuxbrew/bin/brew
  fi

  if [[ -n "$brew" ]]; then
    echo "📦 brew bundle (Brewfile.core)"
    eval "$("$brew" shellenv)"
    HOMEBREW_NO_AUTO_UPDATE=1 timeout 1200 brew bundle --no-upgrade --file="$DOTFILES_DIR/Brewfile.core" ||
      echo "⚠️  brew bundle failed"
  fi

  if command -v nvim > /dev/null 2>&1; then
    echo "📝 neovim plugins"
    # An inherited url.insteadOf may point github.com at an unusable ssh alias.
    GIT_CONFIG_GLOBAL=/dev/null timeout 600 nvim --headless "+Lazy! install" +qa ||
      echo "⚠️  Lazy install failed"
    # The first run quits before async parser builds finish; redo it synchronously.
    GIT_CONFIG_GLOBAL=/dev/null timeout 600 nvim --headless \
      "+lua local ok, err = pcall(function() require('lazy').load({plugins={'nvim-treesitter'}}); local c=require('nvim-treesitter.configs'); require('nvim-treesitter.install').ensure_installed_sync(c.get_ensure_installed_parsers()) end); if not ok then vim.api.nvim_err_writeln(tostring(err)); vim.cmd('cquit 1') end" \
      +qa || echo "⚠️  treesitter parser install failed"
  fi

  if command -v claude > /dev/null 2>&1; then
    echo "🔌 Claude Code plugins"
    local spec
    for spec in "${CLAUDE_PLUGINS[@]}"; do
      claude plugin marketplace add "${spec%%|*}" || echo "⚠️  marketplace add failed: ${spec%%|*}"
      claude plugin install "${spec##*|}" || echo "⚠️  plugin install failed: ${spec##*|}"
    done
  fi

  if command -v python3 > /dev/null 2>&1; then
    echo "📊 Claude Code statusline setting"
    python3 "$DOTFILES_DIR/claude/set-statusline.py" || echo "⚠️  statusline setup failed"
  fi
}

# DOTFILES_SKIP_SETUP lets tests exercise the linking logic without installing anything.
if [[ "$OSTYPE" == linux* && -z "${DOTFILES_SKIP_SETUP:-}" ]]; then
  setup_linux
fi

echo "✨ Dotfiles installation complete!"
if [[ -d "$BACKUP_DIR" ]]; then
  echo "📁 Backups stored in: $BACKUP_DIR"
fi

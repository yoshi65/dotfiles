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

  if ln -sf "$source" "$target"; then
    echo "✓ Linked: $target -> $source"
  else
    echo "✗ Failed to link: $target"
    return 1
  fi
}

# Confirmation prompt (unless --force is used)
if [[ "$FORCE" == false ]]; then
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

echo "🏠 Installing root-level dotfiles..."
for entry in "${HOME_ENTRIES[@]}"; do
    if [[ -e "$DOTFILES_DIR/$entry" ]]; then
        create_symlink "$DOTFILES_DIR/$entry" "$HOME/$entry"
    fi
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

echo "✨ Dotfiles installation complete!"
if [[ -d "$BACKUP_DIR" ]]; then
  echo "📁 Backups stored in: $BACKUP_DIR"
fi

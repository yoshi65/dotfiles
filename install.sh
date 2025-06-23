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

# Process root-level dotfiles (excluding .config)
for f in .??*; do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue
    [[ "$f" == ".gitignore" ]] && continue
    [[ "$f" == ".github" ]] && continue
    [[ "$f" == ".config" ]] && continue  # Handle .config separately

    source="$DOTFILES_DIR/$f"
    target="$HOME/$f"

    create_symlink "$source" "$target"
done

# Handle .config directory contents individually
echo "📁 Installing .config applications..."
if [[ -d "$DOTFILES_DIR/.config" ]]; then
    # List of .config subdirectories to manage
    CONFIG_APPS=(
        "dein"
        "git"
        "nvim"
        "template"
    )

    # List of .config files to manage
    CONFIG_FILES=(
        "flake8"
        "pycodestyle"
    )

    # Create .config directory if it doesn't exist
    mkdir -p "$HOME/.config"

    # Link config directories
    for app in "${CONFIG_APPS[@]}"; do
        if [[ -d "$DOTFILES_DIR/.config/$app" ]]; then
            source="$DOTFILES_DIR/.config/$app"
            target="$HOME/.config/$app"
            create_symlink "$source" "$target"
        fi
    done

    # Link config files
    for file in "${CONFIG_FILES[@]}"; do
        if [[ -f "$DOTFILES_DIR/.config/$file" ]]; then
            source="$DOTFILES_DIR/.config/$file"
            target="$HOME/.config/$file"
            create_symlink "$source" "$target"
        fi
    done
fi

echo "✨ Dotfiles installation complete!"
if [[ -d "$BACKUP_DIR" ]]; then
  echo "📁 Backups stored in: $BACKUP_DIR"
fi

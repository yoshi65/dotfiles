# CLAUDE.md

Guidance for Claude Code (claude.ai/code) when working in this repository.

## Repository Overview

Personal dotfiles for zsh, vim/neovim and tmux. `install.sh` symlinks them into
`$HOME`; nothing is copied, so editing a file here changes the live config.

## Conventions

These are the rules that the code cannot tell you on its own. Everything else —
which plugins are installed, what a keymap does, why a migration happened — is in
the files themselves or in `git log`.

### Configs stay portable

The same files run on macOS and on Linux hosts. Guard anything environment
specific instead of keeping a second copy:

- tool availability: `command -v <tool> > /dev/null` before using it
- macOS-only lines: `[[ "$OSTYPE" == darwin* ]]`
- tmux: `if-shell`

### install.sh links an explicit list, and that is deliberate

`HOME_ENTRIES` and `CONFIG_ENTRIES` in `install.sh` name every entry that reaches
`$HOME`. A new dotfile is *not* linked until it is added there.

Do not replace this with a glob plus exclusions. The repository root also holds
files that must never reach `$HOME` (`.mcp.json`, `.pre-commit-config.yaml`,
`.claude/`, `.omc/`), and a glob links each new one by default — it once would
have replaced the real `~/.claude` with a link into this repository.

`install.sh` warns about entries tracked under `.config/` but missing from
`CONFIG_ENTRIES`, since everything tracked there is meant for `~/.config`.

### .gitignore is a whitelist

`.config/*` ignores everything, then `!.config/nvim/` and friends open specific
paths. A new config needs an entry there *and* in `CONFIG_ENTRIES` to ship.

This keeps credentials, tokens and runtime state that tools scatter through
`.config` out of the repository by default.

## Dependencies

- Moralerspace Nerd Font (the statusline and nvim icons assume it)
- lazy.nvim for neovim plugins, tpm for tmux plugins — both bootstrap themselves

## Key Bindings

- tmux prefix is `C-q`, not the default `C-b`
- tmux panes: `h/j/k/l` to move, `v`/`s` to split

# zmodload zsh/zprof && zprof
# 環境変数の設定
if [[ "$OSTYPE" == darwin* ]]; then
  # PATH設定
  export PATH="$HOME/go/bin:$HOME/homebrew/bin:$HOME/homebrew/opt/mysql@5.7/bin:$HOME/homebrew/opt/llvm/bin:$HOME/homebrew/opt/grep/libexec/gnubin:$HOME/homebrew/opt/gnu-sed/libexec/gnubin:/opt/homebrew/opt/openjdk/bin:$HOME/.volta/bin:$HOME/.cargo/bin:$HOME/.local/bin:/usr/local/bin:/usr/local/lib:$PATH"
  export JAVA_HOME=/opt/homebrew/opt/openjdk
  export LANG=ja_JP.UTF-8
  export DISPLAY=:0.0
  export LESSOPEN='|lessfilter.sh %s'
  export HOMEBREW_CACHE="$HOME/homebrew/cache"
  export HOMEBREW_NO_INSTALL_CLEANUP=1
  setopt no_global_rcs
  export SDKROOT="$(xcrun --sdk macosx --show-sdk-path)"
fi
export XDG_CONFIG_HOME="$HOME/.config"

# brew's bin dir is not on PATH yet at this point (.zprofile / the host rc add it
# later), so also look there when picking the editor and pager.
has_bin() {
  local d
  for d in ${(s.:.)PATH} /opt/homebrew/bin /home/linuxbrew/.linuxbrew/bin; do
    [[ -x "$d/$1" ]] && return 0
  done
  return 1
}
if has_bin nvim; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi
# if bat exist, GIT_PAGER is changed to bat
export PAGER=less
if has_bin bat; then
  export GIT_PAGER='bat --style=plain --pager="less -FRX"'
fi
unfunction has_bin
export LESS='--RAW-CONTROL-CHARS'

if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
fi

# if-form on purpose: a trailing `[ -f ] && .` leaves $?=1 when the file is absent,
# and a non-interactive zsh (e.g. `exec zsh` at the end of an install script) exits
# with that status.
if [ -f "$HOME/.zshenv_local" ]; then
  . "$HOME/.zshenv_local"
fi

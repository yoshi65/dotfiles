# zmodload zsh/zprof && zprof
# 環境変数の設定
export ANYENV_ROOT="$HOME/.anyenv"
export TFENV_ROOT="$HOME/.tfenv"
export PATH="$ANYENV_ROOT/bin:$TFENV_ROOT/bin:/opt/local/bin:/opt/local/Library:/opt/local/libexec/gnubin:$HOME/homebrew/bin:$HOME/homebrew/opt/llvm/bin:/usr/local/bin:/opt/local/sbin:/usr/local/lib:/opt/X11/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
export LANG=ja_JP.UTF-8
export EDITOR=nvim
export PAGER=less
export DISPLAY=:0.0
export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:/opt/local/lib/ImageMagick-6.9.8"
export LESS='--RAW-CONTROL-CHARS'
export LESSOPEN='|lessfilter.sh %s'
export HOMEBREW_CACHE="$HOME/homebrew/cache"

if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
fi

# if bat exist, GIT_PAGER is changed to bat
if type "bat" > /dev/null 2>&1; then
    export GIT_PAGER='bat --style=plain'
fi

setopt no_global_rcs

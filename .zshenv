# 環境変数の設定
export PYENV_ROOT="$HOME/.pyenv"
export RBENV_ROOT="$HOME/.rbenv"
export PATH="$PYENV_ROOT/bin:$RBENV_ROOT/bin:/opt/local/bin:/opt/local/Library:/opt/local/libexec/gnubin:$HOME/homebrew/bin:/usr/local/bin:/opt/local/sbin:/usr/local/lib:/opt/X11/bin:$PATH"
export XDG_CONFIG_HOME="~/.config"
export LANG=ja_JP.UTF-8
export EDITOR=nvim
export PAGER=less
export DISPLAY=:0.0
export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:/opt/local/lib/ImageMagick-6.9.8"
export LESS='--RAW-CONTROL-CHARS'
export LESSOPEN='|lessfilter.sh %s'
export HOMEBREW_CACHE="$HOME/homebrew/cache"

setopt no_global_rcs

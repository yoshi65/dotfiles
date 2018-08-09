# 環境変数の設定
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:/opt/local/bin:/opt/local/Library:/opt/local/libexec/gnubin:/usr/local/bin:/opt/local/sbin:/usr/local/lib:/opt/X11/bin:$PATH"
export XDG_CONFIG_HOME="~/.config"
export LANG=ja_JP.UTF-8
export EDITOR=nvim
export PAGER=less
export GREP_OPTIONS='--color=auto'
export DISPLAY=:0.0
export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:/opt/local/lib/ImageMagick-6.9.8"
export LESS='--RAW-CONTROL-CHARS'
export LESSOPEN='|lessfilter.sh %s'

setopt no_global_rcs

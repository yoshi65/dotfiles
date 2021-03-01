# zmodload zsh/zprof && zprof
# 環境変数の設定
export JAVA_HOME=`/usr/libexec/java_home -v 11`
export ANYENV_ROOT="$HOME/.anyenv"
export TFENV_ROOT="$ANYENV_ROOT/envs/tfenv"
export PATH="$ANYENV_ROOT/bin:$HOME/homebrew/opt/mysql@5.7/bin:$TFENV_ROOT/bin:${JAVA_HOME}/bin:$HOME/homebrew/bin:$HOME/homebrew/opt/llvm/bin:$HOME/homebrew/opt/openjdk/bin:$HOME/homebrew/opt/grep/libexec/gnubin:$HOME/homebrew/opt/gnu-sed/libexec/gnubin:/usr/local/bin:/usr/local/lib:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
export LANG=ja_JP.UTF-8
if type "nvim" > /dev/null 2>&1; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi
# if bat exist, GIT_PAGER is changed to bat
export PAGER=less
if type "bat" > /dev/null 2>&1; then
  export GIT_PAGER='bat --style=plain --pager="less -FRX"'
fi
export DISPLAY=:0.0
export LESS='--RAW-CONTROL-CHARS'
export LESSOPEN='|lessfilter.sh %s'
export HOMEBREW_CACHE="$HOME/homebrew/cache"
export HOMEBREW_NO_INSTALL_CLEANUP=1

if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
fi

setopt no_global_rcs

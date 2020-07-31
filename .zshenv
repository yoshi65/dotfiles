# zmodload zsh/zprof && zprof
# 環境変数の設定
export JAVA_HOME=`/usr/libexec/java_home -v 11`
export ANYENV_ROOT="$HOME/.anyenv"
export TFENV_ROOT="$ANYENV_ROOT/envs/tfenv"
export PATH="$ANYENV_ROOT/bin:$TFENV_ROOT/bin:${JAVA_HOME}/bin:$HOME/homebrew/bin:$HOME/homebrew/opt/llvm/bin:$HOME/homebrew/opt/openjdk/bin:$HOME/homebrew/opt/grep/libexec/gnubin:$HOME/homebrew/opt/gnu-sed/libexec/gnubin:/usr/local/bin:/usr/local/lib:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
export LANG=ja_JP.UTF-8
if type "nvim" > /dev/null 2>&1; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi
# if bat exist, PAGER and GIT_PAGER is changed to bat
if type "bat" > /dev/null 2>&1; then
  export PAGER=bat
  export GIT_PAGER='bat --style=plain'
else
  export PAGER=less
fi
export DISPLAY=:0.0
export LESS='--RAW-CONTROL-CHARS'
export LESSOPEN='|lessfilter.sh %s'
export HOMEBREW_CACHE="$HOME/homebrew/cache"

if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
fi

setopt no_global_rcs


_has() {
  return $( whence $1 &>/dev/null )
}

# Initialize starship (cached if possible)
if command -v starship > /dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Initialize zoxide (cached if possible)
if command -v zoxide > /dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
# Expansion of completion - optimized with caching
# Cache brew prefix for performance
if [[ -z "$HOMEBREW_PREFIX" ]]; then
    export HOMEBREW_PREFIX="${HOME}/homebrew"
fi
if [[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]]; then
    fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
fi
fpath=($fpath ~/.zsh/completion)

# Optimized compinit with caching and skip security checks
autoload -U compinit
# Check if we need to regenerate the dump file
if [[ -z "$ZSH_COMPDUMP" ]]; then
    ZSH_COMPDUMP="$HOME/.zcompdump"
fi

# Only regenerate dump if it's older than 24 hours or doesn't exist
if [[ $ZSH_COMPDUMP(#qNmh+24) ]]; then
    compinit -u -d "$ZSH_COMPDUMP"
else
    compinit -u -C -d "$ZSH_COMPDUMP"
fi

# For aws
autoload bashcompinit && bashcompinit
# complete -C "$(which aws_completer)" aws

# For k8s - lazy load completion
kubectl() {
  if ! command -v kubectl > /dev/null 2>&1; then
    echo "kubectl not found"
    return 1
  fi

  # Load completion on first use
  if [[ -z "$_KUBECTL_COMPLETION_LOADED" ]]; then
    source <(command kubectl completion zsh)
    export _KUBECTL_COMPLETION_LOADED=1
  fi

  command kubectl "$@"
}

# Not case sensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:*files' ignored-patterns '*?.o'

# color
# eval `dircolors`
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# uv completion - lazy load
uv() {
  if ! command -v uv > /dev/null 2>&1; then
    echo "uv not found"
    return 1
  fi

  # Load completion on first use
  if [[ -z "$_UV_COMPLETION_LOADED" ]]; then
    eval "$(command uv generate-shell-completion zsh)"
    export _UV_COMPLETION_LOADED=1
  fi

  command uv "$@"
}

# history
SAVEHIST=100000
HISTSIZE=100000
HISTFILE=~/.zhistory

# aliasd
alias l="eza --icons"
alias ll="eza -l --icons --git"
alias la="eza -la --icons --git"
alias tree="eza --tree --icons"
# alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs -nw"
if command -v nvim > /dev/null 2>&1; then
    alias emacs="nvim"
    alias vi="nvim"
    alias memo="nvim ~/Geektool/geektool_memo.md"
    alias lmemo="nvim ~/Geektool/geektool_lab_memo.md"
fi
alias grep="grep --color=auto"
alias rg="rg --color=always --smart-case"
alias -g G="|grep"
alias -g L="|less"
alias -g H="|head"
# マージ済みブランチを削除（main/master以外）
gbd() {
  git fetch --prune
  git branch --merged | grep -v -e '^*' -e 'main' -e 'master' | xargs -r git branch -d
}
alias grd="cd $(git rev-parse --show-cdup)"
alias gnb="git checkout -b"
alias gc="git commit -m"
alias gp="git push origin"
alias gpf="git push --force-with-lease --force-if-includes origin"
alias gs="git status"
alias gf="git fetch origin"
alias gr="git reset --hard"

function gcm() {
  DEFAULT_BRANCH='master'
  if git branch | ggrep -qP '^[ *]*main$'; then
    DEFAULT_BRANCH='main'
  fi
  git checkout $DEFAULT_BRANCH
  git pull origin $DEFAULT_BRANCH
}

# setopt
setopt IGNORE_EOF #ログアウト防止
setopt HIST_IGNORE_ALL_DUPS #ヒストリ中に同じコマンドを含まないようにする
setopt HIST_REDUCE_BLANKS #コマンド行の余分な空白を詰めてからヒストリに加える
setopt HIST_NO_STORE #ヒストリにhistoryコマンドを残さない
setopt SHARE_HISTORY #複数のzshで利用したコマンドをすぐにヒストリとして利用する
setopt HIST_IGNORE_SPACE #ヒストリに残さないでコマンドを実行する
setopt AUTO_CD #cdコマンドを略す
setopt AUTO_PUSHD #cdコマンドで自動的にpushdする
setopt PUSHD_IGNORE_DUPS #同じディレクトリが重複してディレクトリスタックに積まれないようにする
setopt NUMERIC_GLOB_SORT #文字ではなく、数値としてsortする
setopt CLOBBER # リダイレクトによる上書きを可能にする

if command -v fzf > /dev/null 2>&1; then
  # fzf の キーバインド
  fzf_shell_path="$HOMEBREW_PREFIX/opt/fzf/shell/"
  if [ -e ${fzf_shell_path}key-bindings.zsh ]; then
    source ${fzf_shell_path}key-bindings.zsh
  fi

  # fzf の 補完設定
  if [ -e ${fzf_shell_path}completion.zsh ]; then
    source ${fzf_shell_path}completion.zsh
  fi

  # fzf から ripgrep (rg) を呼び出すことで高速化
  if _has fzf && _has rg; then
    export FZF_DEFAULT_COMMAND='rg --files --color=never --glob "!.git/*"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type d --color=never --glob '!.git/*' 2>/dev/null || find . -type d -name '.git' -prune -o -type d -print 2>/dev/null"
    export FZF_COMMON_MYOPTS="--height 40% --layout=reverse --multi"
    export FZF_DEFAULT_OPTS="$FZF_COMMON_MYOPTS --preview 'bat --color=always {} --style=plain'"
    export FZF_CTRL_T_OPTS="$FZF_COMMON_MYOPTS --bind 'ctrl-y:execute-silent(echo {} | pbcopy)+abort' --border --preview 'bat --color=always {}'"
  fi

  alias f="fzf --preview 'bat --color=always {}'"
  alias F="fzf --height 100% --preview 'bat --color=always {}'"

  # Key bindings for git with fzf
  # https://junegunn.kr/2016/07/fzf-git/
  # https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236
  join-lines() {
    local item
    while read item; do
      echo -n "${(q)item} "
    done
  }

  bind-git-helper() {
    local c
    for c in $@; do
      eval "fzf-g$c-widget() { local result=\$(fzf-g$c | join-lines); zle reset-prompt; LBUFFER+=\$result }"
      eval "zle -N fzf-g$c-widget"
      eval "bindkey '^g^$c' fzf-g$c-widget"
    done
  }

  bind-git-helper f b t r h
  unset -f bind-git-helper

  # GIT heart FZF
  # https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236
  # -------------

  is_in_git_repo() {
      git rev-parse HEAD > /dev/null 2>&1
  }

  fzf-down() {
    fzf --height 50% "$@" --border
  }

  fzf-gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
  --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
  }

  fzf-gb() {
  is_in_git_repo || return
    LINES=200
  git branch -a --color=always | command grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
  --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
  }

  fzf-gt() {
  is_in_git_repo || return
    LINES=200
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
  --preview 'git show --color=always {} | head -'$LINES
  }

  fzf-gh() {
  is_in_git_repo || return
    LINES=200
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
  --header 'Press CTRL-S to toggle sort' \
  --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
  command grep -o "[a-f0-9]\{7,\}"
  }

  fzf-gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
  --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d$'\t' -f1
  }
fi

function getDefaultBrowser() {
	preffile=$HOME/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure
	if [ ! -f ${preffile}.plist ]; then
		preffile=$HOME/Library/Preferences/com.apple.LaunchServices
	fi
# browser might be "com.apple.safari", "org.mozilla.firefox" or "com.google.chrome".
	browser=$(defaults read ${preffile} | grep -B 1 "https" | awk '/LSHandlerRoleAll/{ print $NF }' | sed -e 's/"//g;s/;//')
	echo ${browser}
}

google(){
	local search_string
	for i
		do search_string="$search_string+$i"
	done
	open http://www.google.co.jp/search\?q=$search_string\&hl=ja
}


elatexmk() {
  if [ $# -lt 1 ]; then
    echo "Usage: $0 tex_file"
    echo "Call latexmk with pdflatex. This function might be useful when you want to typeset TeX files in English."
  else
    latexmk -pvc -pdf -pdflatex="pdflatex -interaction=nonstopmode" $1
  fi
}
# Add node_modules to PATH if exists
[[ -d "${HOME}/node_modules/.bin" ]] && export PATH="${PATH}:${HOME}/node_modules/.bin"


batdiff() {
    git diff --name-only --diff-filter=d 2>/dev/null | xargs bat --diff
}

# Load additional configurations
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
[[ -f "$HOME/.zshrc_local" ]] && source "$HOME/.zshrc_local"

# forgit - interactive git with fzf
[[ -f "$HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh" ]] && source "$HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh"

eval "$(/Users/yoshitaka/.local/bin/mise activate zsh)"

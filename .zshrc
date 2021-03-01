
_has() {
  return $( whence $1 &>/dev/null )
}

# setting prompt
autoload -Uz vcs_info
autoload -U colors
colors
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr ": "
zstyle ':vcs_info:git:*' unstagedstr ": "
zstyle ':vcs_info:git:*' formats "%b%c%u"
zstyle ':vcs_info:git:*' actionformats '%b|%a'

precmd () {
        # dir path
        path_prompt="%{${fg[green]}%}%~%{${fg[default]}%}"

        # vcs_info
	psvar=()
	LANG=en_US.UTF-8 vcs_info
	[[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"

        # check if version control by git is done
        current=$PWD
        git_check=1
        while [[ $PWD != '/' ]]
        do
            if [[ -n `ls -a | grep "^\.git$"` ]]; then
                git_check=0
                break
            else
                cd ../
            fi
        done
        cd $current

        # check if branch is master or not
        if [[ `echo $vcs_info_msg_0_ | grep -c "master"` > 0 ]]; then
            branch="  "
        else
            branch=" "
        fi

        # make prompt each git status
	if [[ git_check -eq 0 ]]; then
		st=`git status 2> /dev/null`
		if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
			git_prompt=" [${branch}%1(v|%F{green}%1v%f|)]"
		elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
			git_prompt=" [${branch}%1(v|%F{yellow}%1v%f|)]"
		else [[ -n `echo "$st" | grep "^# Untracked"` ]];
			git_prompt=" [${branch}%1(v|%F{red}%1v%f|)]"
		fi 
	else
		git_prompt=""
	fi

        # env version
        if [[ `ls -1 | grep -c "\.py$"` > 0 ]]; then
            PYTHON_VERSION_STRING=" py:"$(python --version | sed "s/Python //")
            PYTHON_VIRTUAL_ENV_STRING=""
            if [ -n "$VIRTUAL_ENV" ]; then
                PYTHON_VIRTUAL_ENV_STRING=":$(pyenv version-name)"
            fi
        fi
        # RUBY_VERSION_STRING=" rb:"$(ruby --version | sed "s/ruby \(.*\) (.*$/\1/")
        # if [[ `ls -1 | grep -c "\.tf$"` > 0 ]]; then
        #     TERRAFORM_VERSION_STRING=" tf:"$(terraform --version | grep "Terraform" | sed "s/Terraform v//")
        # fi
        
        env_prompt="%{${fg[yellow]}%}${PYTHON_VERSION_STRING}${PYTHON_VIRTUAL_ENV_STRING}%{${fg[magenta]}%}${RUBY_VERSION_STRING}%{${fg[default]}%}${TERRAFORM_VERSION_STRING}"

        if [[ -n `jobs | grep "suspended"` ]]; then
            name_color=${fg[blue]}
        else
            name_color=${fg[cyan]}
        fi

        if type "kube_ps1" > /dev/null 2>&1; then
            kube=" $(kube_ps1)"
        else
            kube=""
        fi

        PS1="%D{%Y-%m-%d %H:%M:%S} %{${name_color}%}%n%{${fg[default]}%} [%m]${env_prompt}${git_prompt} ${path_prompt}${kube}
%% "

        PYTHON_VERSION_STRING=""
        PYTHON_VIRTUAL_ENV_STRING=""
        # TERRAFORM_VERSION_STRING=""
}

if [ -d $ANYENV_ROOT ]; then
  export PATH="$ANYENV_ROOT/bin:$PATH"
  for D in `command ls $ANYENV_ROOT/envs`
  do
    export PATH="$ANYENV_ROOT/envs/$D/shims:$PATH"
  done
fi

function anyenv_init() {
  eval "$(anyenv init - --no-rehash)"
}
function anyenv_unset() {
  unset -f pyenv
  unset -f rbenv
  unset -f nodenv
  unset -f tfenv
}
function pyenv() {
  anyenv_unset
  anyenv_init
  pyenv "$@"
}
function rbenv() {
  anyenv_unset
  anyenv_init
  rbenv "$@"
}
function nodenv() {
  anyenv_unset
  anyenv_init
  nodenv "$@"
}
function tfenv() {
  anyenv_unset
  anyenv_init
  tfenv "$@"
}

# Expansion of completion
if [[ -d $(brew --prefix)/share/zsh/site-functions ]] then
    fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
fi
fpath=($fpath ~/.zsh/completion)
autoload -U compinit
compinit

# For aws
autoload bashcompinit && bashcompinit
complete -C "$ANYENV_ROOT/envs/pyenv/shims/aws_completer" aws

# For k8s
if type "kubectl" > /dev/null 2>&1; then
  source <(kubectl completion zsh)

  kube_ps1_path=$HOME/homebrew/opt/kube-ps1/share/kube-ps1.sh
  if [ -e ${kube_ps1_path} ]; then
    source ${kube_ps1_path}

    function get_cluster_short() {
      if echo "$1" | grep -q -P 'arn:aws:eks'; then
        echo "$1" | cut -d / -f2
      else
        echo "$1"
      fi
    }
    KUBE_PS1_CLUSTER_FUNCTION=get_cluster_short
  fi
fi

# Not case sensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# color
# eval `dircolors`
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# anyenv
# eval "$(anyenv init - --no-rehash)"

# history
SAVEHIST=100000
HISTSIZE=100000
HISTFILE=~/.zhistory

# aliasd
alias l="/bin/ls -FG"
alias ll="/bin/ls -FGl"
# alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs -nw"
if [[ `type nvim | grep -c "not found"` == 0 ]]; then
    alias emacs="nvim"
    alias vi="nvim"
    alias memo="nvim ~/Geektool/geektool_memo.md"
    alias lmemo="nvim ~/Geektool/geektool_lab_memo.md"
fi
alias grep="grep --color=auto"
alias -g G="|grep"
alias -g L="|less"
alias -g H="|head"
alias gbd="git branch | grep -v master | xargs git branch -D"

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

if type "fzf" > /dev/null 2>&1; then
  # fzf の キーバインド
  fzf_shell_path=$(brew --prefix fzf)"/shell/"
  if [ -e ${fzf_shell_path}key-bindings.zsh ]; then
    source ${fzf_shell_path}key-bindings.zsh
  fi
  
  # fzf の 補完設定
  if [ -e ${fzf_shell_path}completion.zsh ]; then
    source ${fzf_shell_path}completion.zsh
  fi
  
  # fzf から the_silver_searcher (ag) を呼び出すことで高速化
  if _has fzf && _has ag; then
    export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
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

ffmp4-speedup-filter () {
	readonly local speed=$1
	local v="[0:v]setpts=PTS/${speed}[v]"
	if [ $speed -le 2 ]; then
		local a="[0:a]atempo=${speed}[a]"
	elif [ $speed -le 4 ]; then
		local a="[0:a]atempo=2,atempo=$speed/2[a]"
	elif [ $speed -le 8 ]; then
		local a="[0:a]atempo=2,atempo=2,atempo=$speed/4[a]"
	fi
	noglob echo -filter_complex "$v;$a" -map [v] -map [a]
}

ffmp4-speedup () {
	if [ $# -lt 2 ]; then
		echo "Usage: $0 file speed"
		echo "Convert movie(file) to nx playback mp4 file."
		echo "(ex.) $0 input.mov 2"
		echo "      will generate 2x playback mp4 file (input_x2.mp4)"
		return
	fi
	red=`tput setaf 1; tput bold`
	green=`tput setaf 2; tput bold`
	reset=`tput sgr0`
	readonly local src=$1
	readonly local speed=$2
	dst=${src:r}_x${speed}.mp4
	readonly local config="-crf 23 -c:a aac -ar 44100 -b:a 64k -c:v libx264 -qcomp 0.9 -preset slow -tune film -threads auto -strict -2"
	readonly local args="-v 0 -i $src $config $(ffmp4-speedup-filter $speed) $dst"
	echo -n "Converting $src to ${speed}x playback as $dst ... "
	ffmpeg `echo $args`
	if [[ $? = 0 ]]; then
		echo "${green}OK${reset}"
	else
		echo "${red}Failed${reset}"
	fi
}

elatexmk() {
  if [ $# -lt 1 ]; then
    echo "Usage: $0 tex_file"
    echo "Call latexmk with pdflatex. This function might be useful when you want to typeset TeX files in English."
  else
    latexmk -pvc -pdf -pdflatex="pdflatex -interaction=nonstopmode" $1
  fi
}
if [ -d ${HOME}/node_modules/.bin ]; then
      export PATH=${PATH}:${HOME}/node_modules/.bin
fi

if (which zprof > /dev/null 2>&1) ;then
    zprof | less
fi

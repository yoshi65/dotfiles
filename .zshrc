#環境変数の設定
export LANG=ja_JP.UTF-8
export EDITOR=emacs
export PAGER=less

#プロンプトの設定
# VCSの情報を取得するzshの便利関数 vcs_infoを使う
autoload -Uz vcs_info
autoload -U colors
colors
#左プロンプトの設定
PS1="%{${fg[cyan]}%}%n%{${fg[default]}%}%% "
# 右プロンプトの設定
# %b ブランチ情報
# %a アクション名(mergeなど)
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr ":!"
zstyle ':vcs_info:git:*' unstagedstr ":?"
zstyle ':vcs_info:git:*' formats "%b%c%u"
zstyle ':vcs_info:git:*' actionformats '%b|%a'
precmd () { 
   psvar=()
   LANG=en_US.UTF-8 vcs_info
   [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"

   if [[ -n `ls -a | grep "^.git$" ` ]]; then #.gitがあるかを判断した
      st=`git status 2> /dev/null`
        if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
          RPROMPT="[%1(v|%F{green}%1v%f|)][%{${fg[green]}%}%~%{${fg[default]}%}]"
        elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
          RPROMPT="[%1(v|%F{yellow}%1v%f|)][%{${fg[green]}%}%~%{${fg[default]}%}]"
        else [[ -n `echo "$st" | grep "^# Untracked"` ]];
          RPROMPT="[%1(v|%F{red}%1v%f|)][%{${fg[green]}%}%~%{${fg[default]}%}]"
        fi 
   else
    RPS1="[%{${fg[green]}%}%~%{${fg[default]}%}]"
   fi
}

#補完機能の拡大
autoload -U compinit
compinit

#補完候補の大文字、小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

#補完候補に色をつける
eval `dircolors`
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

#ヒストリの設定
SAVEHIST=100000
HISTSIZE=100000
HISTFILE=~/.zhistory

#aliasd
alias l="ls -FG"
alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs -nw"
alias -g G="|grep"
alias -g L="|less"
alias -g H="|head"

#setopt
setopt IGNORE_EOF #ログアウト防止
setopt HIST_IGNORE_ALL_DUPS #ヒストリ中に同じコマンドを含まないようにする
setopt HIST_REDUCE_BLANKS #コマンド行の余分な空白を詰めてからヒストリに加える
setopt HIST_NO_STORE #ヒストリにhistoryコマンドを残さない
setopt SHARE_HISTORY #複数のzshで利用したコマンドをすぐにヒストリとして利用する
setopt HIST_IGNORE_SPACE #ヒストリに残さないでコマンドを実行する
setopt AUTO_CD #cdコマンドを略す
setopt NUMERIC_GLOB_SORT #文字ではなく、数値としてsortする

fignore=(.o)
fignore=(~)

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

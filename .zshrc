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
        # left
        if [[ -n `jobs | grep "suspended"` ]]; then
            PS1="%{${fg[blue]}%}%n%{${fg[default]}%}[%m]%% "
        else
            PS1="%{${fg[cyan]}%}%n%{${fg[default]}%}[%m]%% "
        fi
        
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
        if [[ `echo $vcs_info_msg_0_ | grep "master"` ]]; then
            branch="  "
        else
            branch=" "
        fi

        # right
	if [[ git_check -eq 0 ]]; then
		st=`git status 2> /dev/null`
		if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
			RPROMPT="[${branch}%1(v|%F{green}%1v%f|)][%{${fg[green]}%}%~%{${fg[default]}%}]"
		elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
			RPROMPT="[${branch}%1(v|%F{yellow}%1v%f|)][%{${fg[green]}%}%~%{${fg[default]}%}]"
		else [[ -n `echo "$st" | grep "^# Untracked"` ]];
			RPROMPT="[${branch}%1(v|%F{red}%1v%f|)][%{${fg[green]}%}%~%{${fg[default]}%}]"
		fi 
	else
		RPS1="[%{${fg[green]}%}%~%{${fg[default]}%}]"
	fi
}

# Expansion of completion
if [[ -d /opt/local/share/zsh/site-functions ]] then
    fpath=(/opt/local/share/zsh/site-functions $fpath)
fi
autoload -U compinit
compinit

# Not case sensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# color
eval `dircolors`
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# pyenv
eval "$(pyenv init -)"

# history
SAVEHIST=100000
HISTSIZE=100000
HISTFILE=~/.zhistory

# aliasd
alias l="/bin/ls -FG"
alias ll="/bin/ls -FGl"
# alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs -nw"
alias emacs="nvim"
alias vi="nvim"
alias grep="grep --color=auto"
alias -g G="|grep"
alias -g L="|less"
alias -g H="|head"
alias memo="nvim ~/Geektool/geektool_memo.md"
alias lmemo="nvim ~/Geektool/geektool_lab_memo.md"
alias bgrep="python3 ~/git/memogrep/memogrep.py"
alias t="python3 ~/git/yoshi65/translate/trans.py"
alias ldiff="latexdiff-vc -e utf8 -t CFONT --git --flatten --force -d diff -r"

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

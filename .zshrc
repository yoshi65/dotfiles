#プロンプトの設定
# VCSの情報を取得するzshの便利関数 vcs_infoを使う
autoload -Uz vcs_info
autoload -U colors
colors
#左プロンプトの設定
PS1="%{${fg[cyan]}%}%n%{${fg[default]}%}%% "
# 右プロンプトの設定
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
alias vi="nvim"
alias -g G="|grep"
alias -g L="|less"
alias -g H="|head"
alias memo="nvim ~/Geektool/geektool_memo"
alias bgrep="python ~/git/memogrep/memogrep.py"

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


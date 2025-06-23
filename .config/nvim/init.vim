" .vimrcと同じ部分
" setting
"文字コードをUFT-8に設定
set fenc=utf-8
set encoding=utf-8
set fileencodings=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd
" 全ての数値を十進数として扱う
set nrformats=
" ビープ音を鳴らさない
set visualbell t_vb=
set noerrorbells


" 見た目系
" 行番号を表示
set number
" 現在の行を強調表示
set cursorline
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" guifont
set guifont=Ricty-Regular-Powerline:h16


" 検索系
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch


" tab系
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

" 折りたたみ
set foldmethod=marker
set foldmarker=<details>,</details>


" キーマッピング系
" カーソルキー使用不可
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
 " jjで<ESC>
inoremap <silent> jj <ESC>
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk
" タブ系
nnoremap t <Nop>
nnoremap tj <C-w>j
nnoremap tk <C-w>k
nnoremap tl <C-w>l
nnoremap th <C-w>h
nnoremap tJ <C-w>J
nnoremap tK <C-w>K
nnoremap tL <C-w>L
nnoremap tH <C-w>H
nnoremap tn gt
nnoremap tp gT
nnoremap ts :<C-u>sp<CR>
nnoremap tv :<C-u>vs<CR>
nnoremap tt :<C-u>tabnew<CR>
nnoremap tw <C-w>
" ターミナルモード
tnoremap <silent> <ESC> <C-\><C-n>
" Ctrl+nでファイルツリーを表示/非表示する
nnoremap <C-n> :Fern . -reveal=% -drawer -toggle -width=40<CR>

"" Git command aliases and mappings - MOVED TO lazy.nvim
" See .config/nvim/lua/plugins/git.lua for fugitive configuration

"" Insert timestamp after 'LastModified: '
function! LastModified()
if &modified
  let save_cursor = getpos(".")
  let n = min([40, line("$")])
  keepjumps exe '1,' . n . 's#^\(.\{,10}LastModified: \).*#\1' .
        \ strftime('%Y-%m-%d %H:%M:%S %z') . '#e'
  call histdel('search', -1)
  call setpos('.', save_cursor)
endif
endfun
autocmd BufWritePre * call LastModified()

" fzf: a general-purpose command-line fuzzy finder.
set rtp+=/opt/local/share/fzf/vim
" ; を押して buffer の選択
" nmap ; :Buffers<CR>
" <C-t> を押して file の選択
nmap <C-t> :Files<CR>
" <C-g><C-f> で git のファイル選択
nmap <C-g><C-f> :GFiles?<CR>
" <C-g><C-h> で git の commit hash 選択して diff を表示
nmap <C-g><C-h> :Commits<CR>

" treesitter
syntax on
set termguicolors

" .vimrcと異なる部分"
  let g:cache_home = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
  let g:config_home = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME
  " Disable optional providers to avoid warnings
  let g:loaded_node_provider = 0
  let g:loaded_perl_provider = 0
  let g:loaded_ruby_provider = 0
  let g:loaded_python3_provider = 0

	" macのclipboardとyankを統一
	set clipboard=unnamed

  " augroup for autocmds
  augroup MyAutoCmd
  autocmd!
  augroup END

" Load lazy.nvim plugin manager
lua require('config.lazy')

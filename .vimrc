" Setting
" Character code utf-8
set fenc=utf-8
set termencoding=utf-8
set encoding=utf-8
set fileencodings=iso-2022-jp,utf-8,cp932,euc-jp

" No bells
set visualbell t_vb=
set noerrorbells 

" Others
set nobackup
set noswapfile
set autoread
set hidden
set showcmd
set nrformats=


" visual
" syntax
syntax on

" line
set number
highlight LineNr ctermfg=255 ctermbg=235
set cursorline
" set cursorcolumn

" Move cursor to the end of line at the end
set virtualedit=onemore

" Command lin completion
set wildmode=list:longest

" Others
set smartindent
set showmatch
set laststatus=2


" Tab
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab


" Search
" return top
set wrapscan

" Others
" set smartcase
set incsearch
set hlsearch


" key mapping
" Bracket completion
inoremap { {}<Left>
inoremap {<CR> {<CR>}<ESC><S-o>
inoremap ( ()<left>
inoremap (<CR> ()<Left><CR><ESC><S-o>
inoremap [ []<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>

" Cursor key not available
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Move by display line
nnoremap j gj
nnoremap k gk

" jj = <ESC>
inoremap <silent> jj <ESC>

" <ESC><ESC> = Unhighlight
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" tab
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

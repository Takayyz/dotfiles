"---------------------------------
" Vundle
"---------------------------------
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'itchyny/lightline.vim'
Plugin 'itchyny/vim-gitbranch'
Plugin 'preservim/nerdtree'
Plugin 'ryanoasis/vim-devicons'
Plugin 'scrooloose/nerdcommenter'
Plugin 'skanehira/preview-markdown.vim'
Plugin 'thinca/vim-quickrun'
Plugin 'cocopon/iceberg.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'ervandew/supertab'
Plugin 'sheerun/vim-polyglot'
Plugin 'Yggdroot/indentLine'

call vundle#end()
filetype plugin indent on

"---------------------------------
" basic setting
"---------------------------------
" theme color
set background=dark
colorscheme iceberg
" 文字コード
set encoding=utf-8
set fileencoding=utf-8
" 改行コード自動認識
set fileformats=unix,dos,mac
" ビープ音無効
set visualbell t_vb=
" Disable beep
set noerrorbells
" swapファイル生成off
set noswapfile
" deleteキー有効
set backspace=indent,eol,start
" tabインデントレベル設定
set tabstop=2
" インデント増減を同じレベルで
set shiftwidth=2
" 行をまたいで移動
set whichwrap=b,s,h,l,<,>,[,],~
" Ignore case
set ignorecase
" Enable search using lower case
set smartcase
" 検索が末尾に達したら先頭に戻って検索
set wrapscan
" Copy to clip board by yank
set clipboard=unnamed,autoselect

"---------------------------------
" 表示関係
"---------------------------------
" 行番号表示
set number
" 行番号の色や現在行の設定
autocmd ColorScheme * highlight LineNr ctermfg=12
highlight CursorLineNr ctermbg=4 ctermfg=0
" カーソル行ハイライト
set cursorline
" カーソル列ハイライト
set cursorcolumn
highlight clear CursorLine
augroup TransparentBG
  autocmd!
	autocmd Colorscheme * highlight Normal ctermbg=none
	autocmd Colorscheme * highlight NonText ctermbg=none
	autocmd Colorscheme * highlight LineNr ctermbg=none
	autocmd Colorscheme * highlight Folded ctermbg=none
	autocmd Colorscheme * highlight EndOfBuffer ctermbg=none
augroup END
" highlight Normal ctermbg=NONE guibg=NONE
" highlight NonText ctermbg=NONE guibg=NONE
" highlight SpecialKey ctermbg=NONE guibg=NONE
" highlight EndOfBuffer ctermbg=NONE guibg=NONE
" シンタックスハイライト有効
syntax enable
" 検索結果ハイライト有効
set hlsearch
" ルーラー表示
set ruler
" 括弧入力時の対応する括弧を表示
set showmatch
" ウィンドウ幅より長い場合折り返して次の行へ続けて表示
set wrap
" ステータスライン表示
set laststatus=2

" HTML/XML閉じタグ自動補完
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

"---------------------------------
" Key bindings
"---------------------------------
inoremap <silent> jj <ESC>
let mapleader = "\<Space>"
nnoremap <Leader>, :edit ~/.vimrc<CR>
nnoremap <Leader>r :source ~/.vimrc<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
" Escの2回押しでハイライト消去
nnoremap <silent><Esc><Esc> :nohlsearch<CR><ESC>
noremap <Leader>c <Plug>NERDCommenterToggle<CR>
nnoremap <silent><Leader>t :<C-u>NERDTreeToggle<CR>

"---------------------------------
" lightline.vim
"---------------------------------
" getting rit of showmode
set noshowmode
" Set color scheme and show git branch
let g:lightline = {
      \ 'colorscheme': 'iceberg',
      \ 'active': {
      \   'left': [
      \     [ 'mode', 'paste' ],
      \     [ 'gitbranch' ],
      \     [ 'readonly', 'filename', 'modified' ]
      \   ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ }
      \ }

"---------------------------------
" NerdTree
"---------------------------------
let g:NERDTreeShowHidden=1
let g:NERDTreeShowBookmarks=1
" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

"---------------------------------
" NerdCommenter
"---------------------------------
" コメント記号の後にスペース入れる
let g:NERDSpaceDelims=1
" コメント記号を左揃え
let g:NERDDefaultAlign='left'

"---------------------------------
" indentLine
"---------------------------------
let g:indentLine_setColors = 0
let g:indentLine_char = '┊'

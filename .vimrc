"---------------------------------
" Vundle
"---------------------------------
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'skanehira/preview-markdown.vim'
Plugin 'thinca/vim-quickrun'
Plugin 'preservim/nerdtree'
Plugin 'ryanoasis/vim-devicons'
Plugin 'scrooloose/nerdcommenter'
Plugin 'itchyny/lightline.vim'
Plugin 'itchyny/vim-gitbranch'
Plugin 'w0ng/vim-hybrid'

call vundle#end()
filetype plugin indent on

"---------------------------------
" basic setting
"---------------------------------

" theme color
let g:hybrid_use_iTerm_colors = 1
colorscheme hybrid

" 文字コード
set encoding=utf-8
set fileencoding=utf-8

" 改行コード自動認識
set fileformats=unix,dos,mac

" ビープ音無効
set visualbell t_vb=

" swapファイル生成off
set noswapfile

" deleteキー有効
set backspace=indent,eol,start

" tabインデントレベル設定
set tabstop=2

" インデント増減を同じレベルで
set shiftwidth=2

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

"---------------------------------
" NerdTree
"---------------------------------
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
" lightline.vim
"---------------------------------
" getting rit of showmode
set noshowmode

" Set color scheme and show git branch
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }


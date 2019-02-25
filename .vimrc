let g:hybrid_use_iTerm_colors = 1
colorscheme hybrid
syntax on

"行番号表示
set number

"行番号の色や現在行の設定
autocmd ColorScheme * highlight LineNr ctermfg=12
highlight CursorLineNr ctermbg=4 ctermfg=0
set cursorline
highlight clear CursorLine

"シンタックスハイライト
syntax enable

set backspace=indent,eol,start

"ビープ音無効
set visualbell t_vb=


syntax on
set bg=dark
set termguicolors

set nocp
set ttyfast

set guifont=ConsolasDengXianSemiBold\ 14

set backspace=2
set showmatch
set ruler

set mouse=a
set ts=4
set sw=4
set cindent
set cinoptions=:0,l1,g0
set hlsearch

set autochdir
set timeout timeoutlen=1000 ttimeoutlen=15

set title
set scroll=8

set guicursor=

set nu
set signcolumn=no

highlight LineNr ctermfg=lightgrey guifg=#c0c0c0
"highlight PmenuSel ctermbg=242 ctermfg=white guibg=#6f6f6f guifg=#ffffff
"highlight Pmenu ctermbg=252 ctermfg=black guibg=#d7d7d7 guifg=#000000
highlight PmenuSel guibg=#d7d7d7 guifg=#000000
highlight Pmenu guibg=#7f002f guifg=#ffffff

highlight Comment ctermfg=87 guifg=#5fffff

highlight Constant  ctermfg=213 guifg=#ffcfff
highlight String    ctermfg=207 guifg=#ff5fff
highlight Character ctermfg=213 guifg=#ff9fff
highlight Number    ctermfg=123 guifg=#87ffff
highlight! link Boolean Number

highlight Identifier ctermfg=49  guifg=#00ffaf
highlight! link Function Identifier

highlight Statement ctermfg=227 guifg=#ffff67
highlight! link Repeat    Statement
highlight! link Label     Statement
highlight! link Operator  Statement
highlight! link Keyword   Statement
highlight! link Exception Statement

highlight Type ctermfg=121 guifg=#87ffaf
highlight! link StorageClass Type
highlight! link Structure    Type
highlight! link Typedef      Type

highlight Special guifg=#ffd7d7
highlight! link SpecialChar    Special
highlight! link Tag            Special
highlight! link Delimiter      Special
highlight! link SpecialComment Special
highlight! link Debug          Special

highlight MatchParen guibg=#00ffff guifg=#000000

highlight Underlined guifg=#5fd7ff

command W w

if has('nvim')
	command -nargs=* ECHO echo 'Echoing: '+'<args>'
	command -nargs=* C w | rightb 48vnew +call\ termopen('runcpp.C'."<args>")
	command -nargs=* R rightb vs term://runcpp.R <args>
	command -nargs=* CR w | rightb vs term://runcpp.CR <args>
	command S w | execute 'term cfs -F%'
	command GR execute 'term go run %'
	autocmd TermOpen * startinsert
else
	command -nargs=* C w | !echo "Compiling:" && g++ -fsanitize=address -fsanitize=undefined -fsanitize=leak % <args> && echo "Compiled."
	command -nargs=* R !echo "Running:" && ./a.out <args>
	command -nargs=* CR w | !echo "Compiling..." && g++ -fsanitize=address -fsanitize=undefined -fsanitize=leak % <args> && echo "Running:" && ./a.out
	command S w | !cfs -F%
	command GR !go run %
endif


map Q ZZ

augroup vimrc_cmaps
autocmd BufNewFile,BufWritePost,BufRead *.cpp,*.c,*.hpp,*.h      inoremap <buffer> ; <End>;
autocmd BufNewFile,BufWritePost,BufRead *.cpp,*.c,*.hpp,*.h,*.go,*.tex inoremap <buffer> ( ()<Left>
autocmd BufNewFile,BufWritePost,BufRead *.cpp,*.c,*.hpp,*.h,*.go,*.tex inoremap <buffer> [ []<Left>
autocmd BufNewFile,BufWritePost,BufRead *.cpp,*.c,*.hpp,*.h,*.go inoremap <buffer> " ""<Left>
autocmd BufNewFile,BufWritePost,BufRead *.cpp,*.c,*.hpp,*.h,*.go inoremap <buffer> ' ''<Left>
autocmd BufNewFile,BufWritePost,BufRead *.cpp,*.c,*.hpp,*.h,*.go inoremap <buffer> { <End>{<CR>}<Up><End><CR>
autocmd BufNewFile,BufWritePost,BufRead *.cpp,*.c,*.hpp,*.h,*.go inoremap <buffer> <C-]> {}<Left>
autocmd BufNewFile,BufWritePost,BufRead *.tex      inoremap <buffer> { {}<Left>
autocmd BufNewFile,BufWritePost,BufRead *.tex      inoremap <buffer> <C-]> <End>{<CR>}<Up><End><CR>
autocmd BufNewFile,BufWritePost,BufRead *.go map <buffer> <C-]> :rightb split +call\ CocAction("jumpDefinition")<CR>
autocmd BufNewFile,BufWritePost,BufRead *.c,*.cpp,*.h,*.hpp map <buffer> <C-]> :rightb split +call\ CocAction("jumpDeclaration")<CR>
augroup END


set nocp
filetype plugin on

" vim-plug
call plug#begin('~/.vim/plugged')

"Plug 'chxuan/vimplus-startify'
"Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
"Plug 'luochen1990/rainbow'
"Plug 'mdempsky/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Chiel92/vim-autoformat'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'

" Initialize plugin system
call plug#end()

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
  inoremap <silent><expr> <NUL> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif


autocmd CompleteChanged *.go,*.cpp silent! inoremap <expr> <Tab> complete_info()["selected"] != "-1" ? "\<C-Y>" : "\<C-N>\<C-Y>"
"autocmd CompleteChanged *.go,*.cpp silent! inoremap <Esc> <C-Y>
autocmd CompleteDone *.go,*.cpp silent! iunmap <Tab>
"autocmd CompleteDone *.go,*.cpp silent! iunmap <Esc>

autocmd BufWrite *.go Autoformat

set showcmd

let g:airline_mode_map={'s': '选择', 'V': '可视 行', 'ni': '(插入)', 'ic': '插入 补全', 'R': '替换', '': '选择 块', 'no': '等待', '': '可视 块', 'multi': '复合', '__': '------', 'Rv': '可视 替换', 'c': '命令', 'ix': '插入 补全', 'i': '插入', 'n': '正常', 'S': '选择 行', 't': '终端', 'v': '可视'}

let g:airline_section_z='共%L行 %4l行%3v列 %3p%%'

let g:airline_symbols={'space': ' ', 'paste': '粘贴', 'maxlinenr': 'Ln', 'dirty': '!', 'crypt': '加密', 'linenr': 'Cln', 'readonly': '[只读]', 'spell': '拼写', 'modified': '已修改', 'notexists': '不存在', 'keymap': 'Keymap:', 'ellipsis': '...', 'branch': '分支', 'whitespace': '空格'}

let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#trailing_format='[%s] 行尾冗余'
let g:airline#extensions#whitespace#mixed_indent_format='[%s] 缩进格式不一致'
let g:airline#extensions#whitespace#long_format='[%s] 行过长'
let g:airline#extensions#whitespace#mixed_indent_file_format='[%s] 缩进格式不一致'
let g:airline#extensions#whitespace#conflicts_format='[%s] 格式冲突'

let g:airline#extensions#wordcount#formatter#default#fmt='%s 单词'
let g:airline#extensions#wordcount#formatter#default#fmt_short='%s词:'

let g:airline_filetype_overrides = {
  \ 'defx':  ['defx', '%{b:defx.paths[0]}'],
  \ 'gundo': [ 'Gundo', '' ],
  \ 'help':  [ '帮助', '%f' ],
  \ 'minibufexpl': [ 'MiniBufExplorer', '' ],
  \ 'nerdtree': [ get(g:, 'NERDTreeStatusline', 'NERD'), '' ],
  \ 'startify': [ 'startify', '' ],
  \ 'vim-plug': [ '插件', '' ],
  \ 'vimfiler': [ 'vimfiler', '%{vimfiler#get_status_string()}' ],
  \ 'vimshell': ['vimshell','%{vimshell#get_status_string()}'],
  \ }


"source ~/.vim/plugged/vim-airline/autoload/airline/themes/dark-ext.vim
let g:airline#themes#dark#palette.normal_modified = g:airline#themes#dark#palette.normal
let g:airline#themes#dark#palette.insert_modified = g:airline#themes#dark#palette.insert
let g:airline#themes#dark#palette.replace_modified = g:airline#themes#dark#palette.insert_modified
let g:airline#themes#dark#palette.visual_modified = g:airline#themes#dark#palette.visual
"
" For commandline mode, we use the colors from normal mode, except the mode
" indicator should be colored differently, e.g. light green
let s:airline_a_commandline = [ '#00005f' , '#0cff00' , 17  , 40 ]
let s:airline_b_commandline = [ '#ffffff' , '#444444' , 255 , 238 ]
let s:airline_c_commandline = [ '#9cffd3' , '#202020' , 85  , 234 ]
let g:airline#themes#dark#palette.commandline = airline#themes#generate_color_map(s:airline_a_commandline, s:airline_b_commandline, s:airline_c_commandline)

let NERDTreeWinPos="right"
let NERDTreeShowBookmarks=0

nmap <F4> :NERDTreeToggle<CR>

set tags+=~/.cache/ctags

lang zh_CN.UTF-8

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

set noshowmode


set nocompatible

set rtp+=~/.vim/bundle/vundle
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'kana/vim-smartinput'
Bundle 'nevar/revim'
Bundle 'tpope/vim-fugitive'
Bundle 'Gundo'
Bundle 'L9'
Bundle 'dahu/SearchParty'
Bundle 'matchit.zip'
Bundle 'scrooloose/nerdcommenter'
Bundle 'Rainbow-Parenthesis'
Bundle 'git@github.com:seletskiy/vim-refugi'
Bundle 'wojtekmach/vim-rename'
Bundle 'repeat.vim'
Bundle 'git@github.com:seletskiy/vim-colors-solarized'
Bundle 'surround.vim'
Bundle 'tpope/vim-unimpaired'
Bundle 'git@github.com:seletskiy/smarty.vim'
Bundle 'git@github.com:seletskiy/nginx-vim-syntax'
Bundle 'PHP-correct-Indenting'
Bundle 'git@github.com:seletskiy/Command-T'
Bundle 'bling/vim-airline'
Bundle 'SirVer/ultisnips'
Bundle 'epmatsw/ag.vim'
Bundle 'Valloric/YouCompleteMe'
Bundle 'airblade/vim-gitgutter'
Bundle 'lyokha/vim-xkbswitch'

syntax on
filetype plugin on
filetype indent on

" Hack to ensure, that ~/.vim is looked first
set rtp-=~/.vim
set rtp^=~/.vim

set encoding=utf-8
set printencoding=cp1251
set timeoutlen=400
set wildmenu
set undofile
set undodir=$HOME/.vim/tmp/
set directory=$HOME/.vim/tmp/
set ttyfast
set autowrite
set relativenumber
"set hidden
set hlsearch
set incsearch
set history=500
set smartcase
set expandtab
set autoindent
set shiftwidth=4
set softtabstop=4
set tabstop=4
set backspace=2
set laststatus=2
set gdefault
set completeopt-=preview

" autocomplete list numbers
" autoinsert comment leader
" do not wrap line after oneletter word
set formatoptions=qrn1tol

let g:airline_solarized_reduced = 0
let g:airline_powerline_fonts = 1
let g:airline_theme = 'solarized'
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'
let g:airline_branch_prefix = '⭠'
let g:airline_linecolumn_prefix = '⭡'
let g:airline_readonly_symbol = '⭤'
let g:airline_whitespace_symbol = '✶'
let g:airline#extensions#tabline#enabled = 1

let g:XkbSwitchLib = '/usr/lib/libxkbswitch.so'
let g:XkbSwitchEnabled = 1
let mapleader="\<space>"

let g:Powerline_symbols = 'fancy'
let g:ycm_key_list_select_completion = ['<C-N>', '<Down>']

let g:myTabLine_Cache = {}

let g:CommandTUseGitLsFiles = 1
if &term =~ "screen" || &term =~ "xterm"
    let g:CommandTCancelMap = ['<ESC>', '<C-c>']
endif

let g:surround_102 = "\1function: \1(\r)"
let html_no_rendering=1

cmap w!! %!sudo tee > /dev/null %

imap <C-T> <C-O>:call search("[)}\"'`\\]]", "c")<CR><Right>

map <ins> i<ins><esc>
map <C-T> <Leader>t

noremap <leader>v V`]
noremap <leader>p "1p

nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

nnoremap ? ?\v
vnoremap ? ?\v
nnoremap / /\v
vnoremap / /\v

nnoremap <TAB> %
vnoremap <TAB> %

noremap > >>
noremap < <<
imap <silent> <S-TAB> <C-O><<
vmap <silent> <TAB> >gv
vmap <silent> <S-TAB> <gv
vmap <silent> > >gv
vmap <silent> < <gv

inoremap jj <ESC>
nnoremap j gj
nnoremap k gk

nnoremap <F1> <ESC>
nmap <F2> :w<CR>
imap <F2> <ESC><F2>
map <F12> :bufdo bd!<CR><BAR>:tabo<CR>:enew<CR>

map <Leader>1 1gt
map <Leader>2 2gt
map <Leader>3 3gt
map <Leader>4 4gt
map <Leader>5 5gt
map <Leader>6 6gt
map <Leader>7 7gt
map <Leader>8 8gt
map <Leader>9 9gt

nmap <silent> <space><space> <Plug>SearchPartyHighlightClear

augroup syntax_hacks
    au!
    au BufEnter * hi SPM1 ctermbg=1 ctermfg=7
    au BufEnter * hi SPM2 ctermbg=2 ctermfg=7
    au BufEnter * hi SPM3 ctermbg=3 ctermfg=7
    au BufEnter * hi SPM4 ctermbg=4 ctermfg=7
    au BufEnter * hi SPM5 ctermbg=5 ctermfg=7
    au BufEnter * hi SPM6 ctermbg=6 ctermfg=7
augroup end

augroup hilight_over_80
    au!
    au VimResized,VimEnter * set cc= | for i in range(80, &columns) | exec "set cc+=" . i | endfor
augroup end

augroup dir_autocreate
    au!
    autocmd BufWritePre * if !isdirectory(expand('%:h')) | call mkdir(expand('%:h'),'p') | endif
augroup end

augroup skeletons
    au!
    au BufNewFile *.php exec "normal I<?php\<ESC>2o"
    au BufNewFile *.py exec "normal I# coding=utf8\<CR>\<ESC>xxo"
    au BufNewFile rebar.config,*.app.src exec "normal I%% vim: et ts=4 sw=4 ft=erlang\<CR>\<ESC>xx"
augroup end

augroup ft_customization
    au!
    au BufEnter php set noexpandtab
    au FileType sql set ft=mysql
    au FileType tex :e ++enc=cp1251
    au BufEnter /data/projects/*.conf set ft=nginx
    au BufEnter /data/projects/*.conf syn on
    au FileType erlang set comments=:%%%,:%%,:%
augroup end

command! QuickFixOpenAll call QuickFixOpenAll()
function! QuickFixOpenAll()
    if empty(getqflist())
        return
    endif
    let s:prev_val = ""
    for d in getqflist()
        let s:curr_val = bufname(d.bufnr)
        if (s:curr_val != s:prev_val)
            exec "edit " . s:curr_val
        endif
        let s:prev_val = s:curr_val
    endfor
endfunction

fun! g:LightRoom()
    set background=light
    call s:ApplyColorscheme()
    hi underlined cterm=underline
    hi LineNr ctermfg=249 ctermbg=none
    hi SignColumn ctermfg=240 ctermbg=none
    hi Normal ctermbg=none
    hi TabLine ctermfg=1 ctermbg=7 cterm=none
    hi ColorColumn ctermbg=230

    hi TabLineFill ctermfg=1 ctermbg=7 cterm=none
    hi TabLineSel ctermbg=13 ctermfg=15 cterm=bold
    hi TabLineMod ctermbg=1 ctermfg=15 cterm=bold

    let g:airline_solarized_bg='light'
endfun

fun! g:DarkRoom()
    set background=dark
    call s:ApplyColorscheme()
    hi underlined cterm=underline
    hi LineNr ctermfg=238 ctermbg=none
    hi SignColumn ctermfg=240 ctermbg=none
    hi Normal ctermbg=none
    hi ColorColumn ctermbg=235

    hi TabLine ctermfg=247 ctermbg=236 cterm=none
    hi TabLineFill ctermfg=247 ctermbg=236 cterm=none
    hi TabLineSel ctermbg=148 ctermfg=22 cterm=bold
    hi TabLineMod ctermbg=1 ctermfg=15 cterm=bold

    let g:airline_solarized_bg='dark'
endfun

fun! s:ApplyColorscheme()
    let g:solarized_termcolors = 256
    let g:solarized_contrast = 'high'
    colorscheme solarized
    hi! link WildMenu PmenuSel
    hi erlangEdocTag cterm=bold ctermfg=14
    hi erlangFunHead cterm=bold ctermfg=4
endfun

if system('background') == "light\n"
    call g:LightRoom()
else
    call g:DarkRoom()
endif

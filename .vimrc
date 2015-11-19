set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

" let Vundle manage Vundle
" required!
Plugin 'gmarik/Vundle.vim'
Plugin 'seletskiy/vim-over80'
Plugin 'seletskiy/vim-nunu'
Plugin 'altercation/vim-colors-solarized'
Plugin 'Shougo/unite.vim'
Plugin 'yuku-t/unite-git'
Plugin 'Shougo/neomru.vim'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'Gundo'
Plugin 'ervandew/supertab'
Plugin 'Valloric/YouCompleteMe'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'fatih/vim-go'
"Plugin 'seletskiy/vim-pythonx'
Plugin 'cespare/vim-toml'
Plugin 'majutsushi/tagbar'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'osyo-manga/vim-over' " replace with preview
Plugin 'ciaranm/detectindent'

call vundle#end()

" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set update time 500ms
set updatetime=500
" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
filetype on
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" 80 column highlight
set colorcolumn=80

" Higlight cursor position
" set cursorline
" Completion
set completeopt-=preview

" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 3 lines to the cursor - when moving vertically using j/k
set so=3

" A buffer becomes hidden when it is abandoned
"set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=b

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" Display commands
set showcmd

" Display title
set title

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Diff
set dip=filler,vertical

" Enable numbers
set number
let g:my_relative_mode = 0

" Mouse mode
set mouse=nvh
let g:my_mouse_mode = 1

set clipboard+=unnamed " Глобальный буфер обмена (теперь копипаст работает между системой в вимом)

if version >= 700
    set history=64
    set undolevels=1000
endif

" non printable
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('multi_byte')
    if version >= 700
        set listchars=tab:▸\ ,trail:·,eol:¶,extends:→,precedes:←,nbsp:×
    else
        set listchars=tab:▸\ ,trail:·,eol:¶,extends:→,precedes:←,nbsp:_
    endif
endif

" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

"Specify the behavior when switching between buffers
try
 set switchbuf=useopen,usetab,split
 set stal=1
catch
endtry

" => Text, tab and indent related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Show autocomplete menu
set wildmenu

" Be smart when using tabs ;)
"set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Linebreak on 500 characters
"set lbr
"set tw=500

set ai "Auto indent
set si "Smart indent
set nowrap "No wrap lines

" Auto detect indent style
let g:detectindent_preferred_expandtab = 1
let g:detectindent_preferred_indent = 4

" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" solarized colorscheme
let g:solarized_termcolors = 256
let g:solarized_termtrans = 0
set background=light
colorscheme solarized
hi Underlined cterm=underline

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""" Plugins configs """"""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Supertab """"""""""""""""""
"""""""""""""""""""""""""""""
let g:SuperTabDefaultCompletionType = "<c-n>"

" UltiSnip """"""""""""""""""
"""""""""""""""""""""""""""""
set runtimepath+=~/.vim/bundle/ultisnips
let g:UltiSnipsEditSplit = "horizontal"
let g:UltiSnipsSnippetDirectories=["UltiSnips"]

" Airline line """"""""""""""
"""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2
"let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts=1
" old vim-powerline symbols
let g:airline#extensions#whitespace#symbol = '☼'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '│'
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''
let g:airline#extensions#tabline#show_buffers = 0

" Unite """""""""""""""""""""
"""""""""""""""""""""""""""""
let g:unite_split_rule = "botright"
let g:unite_enable_start_insert = 1
let g:unite_source_history_yank_enable = 1
let g:unite_source_history_yank_file = $HOME.'/.vim/yankring.txt'

augroup unite_custom
    au!
    au VimEnter * call unite#custom#source(
                \ 'file,file/new,buffer,file_rec,file_rec/async,git_cached,git_untracked,directory',
                \ 'matchers', 'matcher_fuzzy')

    au VimEnter * call unite#custom#default_action(
                \ 'directory', 'cd')

    au VimEnter * call unite#filters#sorter_default#use(['sorter_selecta'])
augroup end

call unite#filters#sorter_default#use(['sorter_rank'])

function! s:unite_rec_git_or_file()
    if fugitive#head() == ""
        :Unite file_rec
    else
        :Unite git_cached git_untracked
    endif
endfunction

function! s:unite_my_settings()
    " Overwrite settings.
    imap <silent><buffer><expr> <C-s>     unite#do_action('split')
    nmap <silent><buffer><expr> <C-s>     unite#do_action('split')
    imap <silent><buffer><expr> <C-v>     unite#do_action('right')
    nmap <silent><buffer><expr> <C-v>     unite#do_action('right')
endfunction

augroup unite_autocmd
    au!
    autocmd FileType unite call s:unite_my_settings()
augroup end

nmap <c-t> :Unite -hide-source-names file_rec<CR>
nmap <c-p> :Unite -hide-source-names git_cached git_untracked buffer<CR>
nmap <c-u> :Unite -hide-source-names buffer<CR>
nmap <c-y> :Unite -hide-source-names history/yank<CR>
map <C-E><C-U> :Unite -hide-source-names buffer file_rec/async<CR>
map <C-E><C-G> :Unite -hide-source-names grep:.<CR>
map <C-E><C-E> :Unite -hide-source-names directory:~/dev/<CR>
map <C-E><C-R> :UniteResume<CR>

" Ash section
"""""""""""""""""""""""""""""
augroup syntax_hacks
    au!
    au FileType diff syn match DiffComment "^#.*"
    au FileType diff syn match DiffCommentIgnore "^###.*"
    au FileType diff call g:ApplySyntaxForDiffComments()
augroup end


fun! g:ApplySyntaxForDiffComments()
    if &background == 'light'
        hi DiffCommentIgnore ctermfg=249 ctermbg=none
        hi DiffComment ctermfg=16 ctermbg=254
    else
        hi DiffCommentIgnore ctermfg=249 ctermbg=none
        hi DiffComment ctermfg=15 ctermbg=237
    endif
endfun


" NERDTree """"""""""""""""""
"""""""""""""""""""""""""""""
let NERDTreeIgnore=['\.pyc$','\~$','__pycache__', '\.zip$', '\.tar$', '\.tar\.gz$']
let NERDTreeShowLineNumbers = 0
let NERDTreeMinimalUI=1

" YouCompleteMe """""""""""""
"""""""""""""""""""""""""""""
let g:ycm_min_num_identifier_candidate_chars = 1
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_auto_trigger = 1
let g:ycm_error_symbol = '✗'
let g:ycm_warning_symbol = '⚡'
let g:ycm_key_list_select_completion = ['<C-N>', '<Down>']
let g:ycm_allow_changing_update_time = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""" Mappings """""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap > >>
noremap < <<

" vim-over
"""""""""""""""""""
nnoremap H :OverCommandLine<cr>%s/\v
vnoremap H :OverCommandLine<cr>s/\v

" tagbar
""""""""""""""""""
nmap <F8> :TagbarOpen fjc<CR>

" vim-go
""""""""""""""""""
augroup go_confs
    au!
    au FileType go setl noexpandtab

    au FileType go nmap <leader>r <Plug>(go-run)
    au FileType go nmap <leader>b <Plug>(go-build)
    au FileType go nmap <leader>t <Plug>(go-test)
    au FileType go nmap <Leader>i <Plug>(go-info)
    au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
    au FileType go nmap <Leader>gd <Plug>(go-doc)
    au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
    au FileType go nmap <Leader>i <Plug>(go-info)
    au FileType go nmap gd <Plug>(go-def)
    au FileType go nmap <Leader>ds <Plug>(go-def-split)
    au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
    au FileType go nmap <Leader>dt <Plug>(go-def-tab)

    " play.golang.org ft and syntax
    function! s:playground()
        set syntax=go ft=go
    endfunction

    au BufRead *play.golang.org* call s:playground()
    au BufReadPost *play.golang.org* call s:playground()
augroup end

let g:go_fmt_command = "goimports"

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = " "
let g:mapleader = " "

" Easy-motion
""""""""""""""""""""""""
let g:EasyMotion_do_mapping = 0
map <Leader> <Plug>(easymotion-prefix)
let g:EasyMotion_smartcase = 1
nmap <leader>s <Plug>(easymotion-s2)
nmap <leader>j <Plug>(easymotion-j)
nmap <leader>k <Plug>(easymotion-k)
nmap <leader>/ <Plug>(easymotion-sn)

nmap <leader>qqq :bw<CR>

" Fast saving
nmap <leader>w :w<cr>
" Show non printable characters
nmap <leader>l :set list!<CR>
" Toggle mouse selection
nmap <leader>m :call ToggleMouse()<cr>

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>
"
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :bd<cr>

" Useful mappings for managing tabs
nmap <silent> <leader>cd :lcd %:p:h<cr>:pwd<cr>
nmap T :tabnew

" Remap VIM 0 to first non-blank character
map 0 ^

map <leader>cc :botright cope<cr>
map <leader>] :cn<cr>
map <leader>[ :cp<cr>

" Gundo
nnoremap <leader>gu :GundoToggle<CR>


" Ultisnips
nmap <leader>ss :UltiSnipsEdit<CR>

" NERDTree
nnoremap <leader>e :NERDTreeToggle<CR>

" Fugitive mappings
nnoremap <Leader>gs :Gstatus<cr>

" Tab swtich with c-pgUp & c-pgDown
nmap    <ESC>[5^    <C-PageUp>
nmap    <ESC>[6^    <C-PageDown>
nnoremap  <C-PageDown> :tabn<cr>
nnoremap  <C-PageUp> :tabp<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>mmm mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Toggle relative numbers
nnoremap <Leader>n :call NumberToggle()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""" Functions """"""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable mouse in visual, normal and help modes
function! ToggleMouse()
 if(g:my_mouse_mode == 0)
  set mouse=nvh
  let g:my_mouse_mode = 1
 else
  set mouse=
  let g:my_mouse_mode = 0
 endif
endfunc

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Auto exec
function! ModeChange()
    if getline(1) =~ "^#!"
        if getline(1) =~ "bin/"
            silent !chmod a+x <afile>
        endif
    endif
endfunction

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                   \ | wincmd p | diffthis
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""" Auto commands """"""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup common_cmds
    au!
    "Move quickfix window to very bottom
    autocmd FileType qf wincmd J
    " Close nerd tree if it is the only window
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

    " Return to last edit position when opening files (You want this!)
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif

    " Add execution writes if file starts with #! and contains bin
    autocmd BufWritePost * call ModeChange()
augroup end

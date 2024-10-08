let mapleader=","

" Packages
packadd! editorconfig

" Plugins
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !mkdir -p '~/.vim/autoload'
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync
endif

call plug#begin('~/.vim/plugged')

" base
Plug 'tpope/vim-sensible'

" style
Plug 'jonpas/gruvbox', { 'branch': 'jonpas' }
Plug 'itchyny/lightline.vim'
Plug 'chrisbra/Colorizer'

" utility
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'

" git
Plug 'tpope/vim-fugitive'
Plug 'sjl/gundo.vim'
Plug 'airblade/vim-gitgutter'

" language
Plug 'sheerun/vim-polyglot'
Plug 'jonpas/vim-sqf-syntax', { 'for': 'sqf', 'branch': 'c-like' }
Plug 'othree/xml.vim', { 'for': 'xml' }
Plug 'rust-lang/rust.vim', { 'for': ['rust', 'rhai'] }
Plug 'cespare/vim-toml', { 'for': 'toml', 'branch': 'main' }
Plug 'chrisbra/csv.vim', { 'for': 'csv' }
Plug 'wuelnerdotexe/vim-astro'

" language utility
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'jupyter-vim/jupyter-vim', { 'for': 'python' }

" linting
Plug 'dense-analysis/ale'
Plug 'maximbaz/lightline-ale'
Plug '~/.vim/local/vim-sqflint-ale', { 'for': 'sqf' }
Plug '~/.vim/local/vim-platformio-ale'

" style - must be last ones
Plug 'ryanoasis/vim-devicons'

call plug#end()

runtime ftplugin/man.vim

" Templates
augroup templates
    autocmd BufNewFile *.sh 0r ~/.vim/templates/skeleton.sh
    autocmd BufNewFile *.py 0r ~/.vim/templates/skeleton.py
augroup END

" Style (color list: http://jonasjacek.github.io/colors/)
set background=dark
colorscheme gruvbox
set cursorline
set lazyredraw

" Whitespace
set list
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Indentation
set expandtab
set tabstop=8
set shiftwidth=4
set softtabstop=4

" Maximum line length marker
set colorcolumn=121
highlight ColorColumn ctermbg=darkgray

" Code Folding
set foldmethod=indent
set foldcolumn=1
set foldlevelstart=99

" Wrapping
set wrap
set linebreak
set showbreak=…

" Backup
set updatetime=750

" Navigation
set mouse=a
set ttymouse=sgr " Vim does not recognize Alacritty as SGR-supported terminal

" Layout
set showtabline=2
set noshowmode " disable insert mode information in command line
set number relativenumber
au VimResized * exe "normal! \<c-w>="

" Splits
set splitright
set diffopt+=vertical
silent! set splitvertical
if v:errmsg != ''
    " support for no splitvertical
    cabbrev split vert split
    cabbrev hsplit split
    cabbrev help vert help
    noremap <C-w>] :vert botright wincmd ]<CR>
    noremap <C-w><C-]> :vert botright wincmd ]<CR>
else
    cabbrev hsplit hor split
endif

" Searching
set hlsearch
set ignorecase
set smartcase
set rtp+=/usr/bin/fzf

" Highlighting
autocmd FileType css ColorHighlight
au BufRead,BufNewFile *.asm set filetype=nasm
au BufRead,BufNewFile *.rhai set filetype=rust

" Keybinds
set showcmd
set clipboard=unnamedplus " use system clipboard
" make Y work from the cursor to the end of line (like C and D)
map Y y$
set pastetoggle=<F2>
" clear last used search pattern
nnoremap <CR> :let @/ = ""<CR>:<BACKSPACE><CR>


" Disable arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

nnoremap <F4> :GundoToggle<CR>
nnoremap <F5> :NERDTreeTabsToggle<CR>
nnoremap <F6> :NERDTreeTabsFind<CR>
nnoremap <Left> :tabp<CR>
nnoremap <Right> :tabn<CR>
map <F9> :set path += "."<CR><C-w>gf
nnoremap gb :make<CR> <bar> :cwindow<CR>
nnoremap <F12> :tabe ~/.vimrc<CR>
nnoremap <Up> :cprev<CR>
nnoremap <Down> :cnext<CR>
nnoremap <Space> za

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

nmap <C-p> :FZF<CR>
nmap <C-s> <Plug>MarkdownPreview

" Ex commands
" simplify saving and closing when shift held for too long
command -bang WQ wq
command -bang Wq wq
command -bang W w
command -bang Q q

" Lightline
let g:lightline = {
\   'active': {
\       'left': [ [ 'mode', 'paste' ],
\                 [ 'gitbranch', 'readonly' ] ],
\       'right': [ [ 'lineinfo' ],
\                  [ 'percent' ],
\                  [ 'fileformat', 'fileencoding', 'filetype' ],
\                  [ 'linter_checking', 'linter_errors', 'linter_warnings' ] ],
\   },
\   'component_function': {
\       'gitbranch': 'FugitiveHead',
\   },
\   'component_expand': {
\       'linter_checking': 'lightline#ale#checking',
\       'linter_warnings': 'lightline#ale#warnings',
\       'linter_errors': 'lightline#ale#errors',
\   },
\   'component_type': {
\       'linter_checking': 'right',
\       'linter_warnings': 'warning',
\       'linter_errors': 'error',
\   },
\}

" tabline same colors as statusline
let g:lightline#colorscheme#default#palette.normal.right[0] = g:lightline#colorscheme#default#palette.normal.left[0]
let g:lightline#colorscheme#default#palette.tabline.middle[0] = g:lightline#colorscheme#default#palette.normal.middle[0]
let g:lightline#colorscheme#default#palette.tabline.left[0] = g:lightline#colorscheme#default#palette.normal.left[1]
let g:lightline#colorscheme#default#palette.tabline.tabsel[0] = g:lightline#colorscheme#default#palette.normal.left[0]

" fzf
let g:fzf_layout = { 'down': '40%' }

" integrate ALE
let g:lightline#ale#indicator_checking = ""
let g:lightline#ale#indicator_warnings = ""
let g:lightline#ale#indicator_errors = ""

" Fugitive
set diffopt+=vertical

" Markdown Preview
let g:mkdp_auto_close = 0

" Linters
"let g:ale_enabled = 0
let g:ale_linters = { 'rust': ['analyzer'] }
let g:ale_fixers = { 'rust': ['rustfmt'] }
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
let g:ale_python_flake8_options="--max-line-length=160"
let g:ale_echo_msg_format = '[%linter%] %code: %%s'

" jupyter-vim
let g:jupyter_mapkeys = 0
autocmd FileType python nnoremap <buffer> <silent> <Leader>e :JupyterSendCell<CR>
autocmd FileType python nnoremap <buffer> <silent> <Leader>E :JupyterSendCell<CR>/# %%<CR>zz
autocmd FileType python vmap <buffer> <silent> <Leader>e <Plug>JupyterRunVisual

" HexMode
" ex command for toggling hex mode
command -bar Hexmode call ToggleHex()

" Save su-owned file as user
cmap w!! %!sudo tee > /dev/null %


" Helper functions
" Toggle hex mode
function ToggleHex()
    " hex mode should be considered a read-only operation
    " save values for modified and read-only for restoration later,
    " and clear the read-only flag for now
    let l:modified=&mod
    let l:oldreadonly=&readonly
    let &readonly=0
    let l:oldmodifiable=&modifiable
    let &modifiable=1
    if !exists("b:editHex") || !b:editHex
        " save old options
        let b:oldft=&ft
        let b:oldbin=&bin
        " set new options
        setlocal binary " make sure it overrides any textwidth, etc.
        silent :e " this will reload the file without trickeries
                            "(DOS line endings will be shown entirely )
        let &ft="xxd"
        " set status
        let b:editHex=1
        " switch to hex editor
        %!xxd
    else
        " restore old options
        let &ft=b:oldft
        if !b:oldbin
            setlocal nobinary
        endif
        " set status
        let b:editHex=0
        " return to normal editing
        %!xxd -r
    endif
    " restore values for modified and read only state
    let &mod=l:modified
    let &readonly=l:oldreadonly
    let &modifiable=l:oldmodifiable
endfunction

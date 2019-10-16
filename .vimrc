let mapleader=","

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
Plug 'editorconfig/editorconfig-vim'

" style
Plug 'jonpas/gruvbox', { 'branch': 'jonpas' }
Plug 'itchyny/lightline.vim'
Plug 'chrisbra/Colorizer'
Plug 'ryanoasis/vim-devicons'

" utility
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'

" git
Plug 'tpope/vim-fugitive'
Plug 'sjl/gundo.vim'
Plug 'airblade/vim-gitgutter'

" language
Plug 'sheerun/vim-polyglot'
Plug 'jonpas/vim-sqf-syntax', { 'branch': 'c-like' }
Plug 'othree/xml.vim'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
Plug 'chrisbra/csv.vim'

" language utility
Plug 'JamshedVesuna/vim-markdown-preview', { 'for': 'markdown' }

" linting
Plug 'dense-analysis/ale'
Plug 'maximbaz/lightline-ale'
Plug '~/.vim/local/vim-sqflint-ale'
Plug '~/.vim/local/vim-platformio-ale'

call plug#end()

runtime ftplugin/man.vim

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
autocmd FileType make set expandtab ts=4 sts=4 sw=4

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
set noshowmode " diable insert mode information in command line
set number relativenumber
au VimResized * exe "normal! \<c-w>="

" Splits
set splitright
set diffopt+=vertical
silent! set splitvertical
if v:errmsg != ''
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

" Keybinds
set showcmd
set pastetoggle=<F2>
nnoremap <CR> :let @/ = ""<CR>:<BACKSPACE><CR>

nnoremap <F4> :GundoToggle<CR>
nnoremap <F5> :NERDTreeTabsToggle<CR>
nnoremap <F6> :NERDTreeTabsFind<CR>
nnoremap <F7> :tabp<CR>
nnoremap <F8> :tabn<CR>
map <F9> :set path += "."<CR><C-w>gf
nnoremap gb :make<CR> <bar> :cwindow<CR>
nnoremap <F12> :tabe ~/.vimrc<CR>
nnoremap <Left> :cprev<CR>
nnoremap <Right> :cnext<CR>
nnoremap <Space> za
map <leader>y "+y
map <leader>p "+p

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

if has("nvim")
    tnoremap <Esc> <C-\><C-n>
endif

" Ex commands
" simplify saving and closing when shift held for too long
command WQ wq
command Wq wq
command W w
command Q q

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
\       'gitbranch': 'fugitive#head',
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

" integrate ALE
let g:lightline#ale#indicator_checking = ""
let g:lightline#ale#indicator_warnings = ""
let g:lightline#ale#indicator_errors = ""

" Fugitive
set diffopt+=vertical

" NERDTree
let NERDTreeIgnore = ["\.pyc$", "\.o$", "\.class$", "\.rcg$", "\.rcl$"]

" Markdown Preview
let vim_markdown_preview_github = 1
let vim_markdown_preview_use_xdg_open = 1
let vim_markdown_preview_hotkey = '<C-m>'

" Linters
let g:ale_disable_lsp = 1 " coc's job
let g:ale_python_flake8_options="--max-line-length=120"

" HexMode
" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
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

" Save su-owned file as user
cmap w!! %!sudo tee > /dev/null %

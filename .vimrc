set encoding=utf-8
set nocompatible
let mapleader=","

call pathogen#infect()
call pathogen#helptags()
filetype plugin on
runtime ftplugin/man.vim

" Style (color list: http://jonasjacek.github.io/colors/)
syntax on
set synmaxcol=500
set background=dark
colorscheme gruvbox
set cursorline
set lazyredraw

" Whitespace
set listchars=tab:>·,trail:~
set list
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Make background transparent
highlight Normal ctermbg=None
highlight Folded ctermbg=None
highlight NonText ctermbg=None
highlight LineNr ctermbg=None

" Indentation
set expandtab
set tabstop=8
set shiftwidth=4
set softtabstop=4
set autoindent
autocmd FileType make set expandtab ts=4 sts=4 sw=4

" Code Folding
set foldmethod=indent
set foldcolumn=1
set foldlevelstart=99

" Wrapping
set wrap
set linebreak
set showbreak=…

" Disable swap files (that's what git is for)
set updatetime=500
set nobackup
set noswapfile

" Navigation
set mouse=a
set scrolloff=2
set backspace=indent,eol,start
set ttymouse=sgr " Vim does not recognize Alacritty as SGR-supported terminal

" Layout
autocmd FileType css ColorHighlight
set number relativenumber
set laststatus=2
set equalalways
let g:gitgutter_max_signs = 3000
set tabpagemax=100
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

" Sessions
let g:session_autosave = "no"

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set rtp+=/usr/bin/fzf
let g:ackprg = "ag --vimgrep --smart-case"
cnoreabbrev ag Ack

" Fugitive
set diffopt+=vertical

" NERDTree
let NERDTreeIgnore = ["\.pyc$", "\.o$", "\.class$", "\.rcg$", "\.rcl$"]

" Syntax Highlighting
au BufRead,BufNewFile *.asm set filetype=nasm

" Keybinds
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
vmap <C-C> "+y

if has("nvim")
    tnoremap <Esc> <C-\><C-n>
endif

" Ex commands
" Simplify saving and closing when shift held for too long
command WQ wq
command Wq wq
command W w
command Q q

" clang_complete
let g:clang_library_path = '/usr/lib/libclang.so'

" Markdown Preview
let vim_markdown_preview_github = 1
let vim_markdown_preview_use_xdg_open = 1
let vim_markdown_preview_hotkey = '<C-m>'

" Lightline
let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'relativepath', 'modified' ] ]
    \ },
    \ 'colorscheme': 'default',
    \ 'separator': { 'left': "\ue0b8", 'right': "\ue0ba" },
    \ 'subseparator': { 'left': "\ue0b9", 'right': "\ue0bb" },
    \ 'tabline_separator': { 'left': "\ue0bc", 'right': "\ue0be" },
    \ 'tabline_subseparator': { 'left': "\ue0bb", 'right': "\ue0ba" },
    \ }

let g:lightline#colorscheme#default#palette.normal.right[0] = g:lightline#colorscheme#default#palette.normal.left[0]
let g:lightline#colorscheme#default#palette.tabline.middle[0] = g:lightline#colorscheme#default#palette.normal.middle[0]
let g:lightline#colorscheme#default#palette.tabline.left[0] = g:lightline#colorscheme#default#palette.normal.left[1]
let g:lightline#colorscheme#default#palette.tabline.tabsel[0] = g:lightline#colorscheme#default#palette.normal.left[0]

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

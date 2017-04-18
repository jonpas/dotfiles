set encoding=utf-8
set nocompatible
let mapleader=","

call pathogen#infect()
call pathogen#helptags()
filetype plugin on

" Style (color list: http://jonasjacek.github.io/colors/)
syntax on
set background=dark
colorscheme gruvbox
set cursorline

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
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

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

" Layout
autocmd BufEnter * ColorHighlight
set number
set laststatus=2
set equalalways
let g:gitgutter_max_signs = 3000
set tabpagemax=100

" Searching
set hlsearch
set incsearch
set smartcase

" NERDTree
let NERDTreeIgnore = ["\.pyc$", "\.o$", "\.class$", "\.rcg$", "\.rcl$"]

" Keybinds
set pastetoggle=<F2>
nnoremap <CR> :let @/ = ""<CR>:<BACKSPACE><CR>
nnoremap <F4> :GundoToggle<CR>
nnoremap <F5> :NERDTreeTabsToggle<CR>
nnoremap <F6> :NERDTreeTabsFind<CR>
nnoremap <F7> :tabp<CR>
nnoremap <F8> :tabn<CR>
nnoremap <Left> :cprev<CR>
nnoremap <Right> :cnext<CR>
nnoremap <Space> za
vmap <C-C> "+y

if has("nvim")
    tnoremap <Esc> <C-\><C-n>
endif

" Airline
let g:airline_left_sep = ""
let g:airline_right_sep = ""

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_buffers = 0

let g:airline_theme = 'custom'
let g:airline#themes#custom#palette = {}
let s:N1 = [ '#005f00' , '#aeee00' , 22  , 154 ]
let s:N2 = [ '#a8a8a8' , '#45413b' , 248 , 238 ]
let s:N3 = [ '#8a8a8a' , '#242321' , 245 , 235 ]
let s:I1 = [ '#005f5f' , '#ffffff' , 23  , 15  ]
let s:I2 = [ '#00d7ff' , '#0087af' , 45  , 31  ]
let s:I3 = [ '#00d7ff' , '#005f87' , 45  , 24  ]
let s:R1 = [ '#ffffff' , '#d70000' , 15  , 160 ]
let s:V1 = [ '#d75f00' , '#ffaf00' , 166 , 214 ]
let s:M  = [ '#ff8700', 208 ]
let g:airline#themes#custom#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#custom#palette.normal_modified = {
    \ 'airline_c': [ s:M[0], s:N3[1], s:M[1], s:N3[3], '' ] }
let g:airline#themes#custom#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#custom#palette.insert_modified = {
    \ 'airline_c': [ s:M[0], s:I3[1], s:M[1], s:I3[3], '' ] }
let g:airline#themes#custom#palette.replace = airline#themes#generate_color_map(s:R1, s:N2, s:N3)
let g:airline#themes#custom#palette.replace_modified = g:airline#themes#custom#palette.normal_modified
let g:airline#themes#custom#palette.visual = airline#themes#generate_color_map(s:V1, s:N2, s:N3)
let g:airline#themes#custom#palette.visual_modified = g:airline#themes#custom#palette.normal_modified
let g:airline#themes#custom#palette.inactive = airline#themes#generate_color_map(s:N2, s:N2, s:N3)

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

" Ag
let g:ackprg = "ag --vimgrep --smart-case"
cnoreabbrev ag Ack

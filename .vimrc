" TODO no extension file, do folds permanently, probably must be some syntax?
" TODO to have highligting for no extension files(e.g. highlight words like URGENT, TODO, ...) ofcourse do it in vimrc
" TODO Bind in search mode ctrl-shift-v to insert " register
" TODO I like how browsers do bookmarks
" you press one button and website is saved as bookmark
" later it can be found at the bottom of bookmark's list
" TODO vim bug when I press - it doesn't highlight on first launch
" ./snap/firefox/common/.mozilla/firefox/jhcujgg3.default/places.sqlite
"TODO make linux rm mv files to some folder(check vim netrw will use it also)(ask gpt)
"TODO create combo that saves current file full path to some file(appends)
"     in future this file can be used to revisit any file on pc that was once interesting
"TODO mark file to be available on all instances of vim(maybe create some mechanism for saving important files)
"TODO Today macro should also contain time(22:02)
"TODO use some shotgun app to do screenshots and copy filename to clipboard
"TODO if I open up several vim windows will higlight be shared?

"TODO I want to open up vim in ssh session and copy to my laptop clipboard
"TODO copy cur file name (relative to pwd) to clipboard(")

"TODO open current term view in temp vim instance
"TODO bind hot key for ubuntu term move window to other monitor
"TODO I hold a button but there is some delay before pc starts to repeatadly treat it as continuous button pressing - reduce this timeout
"TODO on :q go to left tab instead of right
"TODO I need some key to save current view and than come to same view with another key(or same)(one view saved max) when comeback erases
"TODO git status/diff -> file names -> open in vim
"TODO <esc>OR prints <F3> xD
"TODO rename current file OR add some word to current file's name
"TODO try server client
"TODO Create Yesterday macro
" i open several vim sessions
" but they all share same buffers

set textwidth=0
func! Today()
return strftime('%a %d %b %Y')
endfunc

set mouse=a
set autoread

nnoremap <F2> :call SwitchSourceHeader()<CR>

nnoremap <F12> :tab split<CR>

function! SwitchSourceHeader()
    let l:file = expand('%:t:r')          " filename without extension
    let l:path = expand('%:p:h')          " directory of current file
    let l:ext  = expand('%:e')            " extension (cc, hh, etc.)

normal mf

    if l:ext ==# 'cc' || l:ext ==# 'cpp' || l:ext ==# 'c'
        for ext in ['hh', 'hpp', 'h']
            if filereadable(l:path . '/' . l:file . '.' . ext)
                execute 'edit ' . l:path . '/' . l:file . '.' . ext
            endif
        endfor
    elseif l:ext ==# 'hh' || l:ext ==# 'hpp' || l:ext ==# 'h'
        for ext in ['cc', 'cpp', 'c']
            if filereadable(l:path . '/' . l:file . '.' . ext)
                execute 'edit ' . l:path . '/' . l:file . '.' . ext
            endif
        endfor
    else
    endif

silent! normal `f
endfunction


set expandtab      " convert tabs to spaces
set tabstop=4      " number of spaces a <Tab> counts for
set shiftwidth=4   " number of spaces for autoindent
set softtabstop=4  " number of spaces when pressing <Tab>

let g:netrw_sort_by = "time"
let g:netrw_sort_direction = "reverse"
"let g:netrw_keepdir = 0
"let g:netrw_banner=0
let g:netrw_list_hide = '\.\.\/\|\.\/' "hides . and .. directories

set noswapfile

if has('win32') || has('win64')
cd ~/Desktop
set clipboard=unnamed
else
set clipboard=unnamedplus
endif

set complete=.,w
set incsearch

map Y y$
let g:threads = 12
let g:file_types = "thrift,cc,hh,c,h,cpp,hpp,txt"
let &grepprg = 'rg --vimgrep --threads=' . g:threads . ' -g "*.{' . g:file_types . '}" -F'
set wildmode=noselect:lastused,full
set wildoptions=pum
set findfunc=MyCustomFind 

func! MyCustomFind(arg, _) 
let l:files = _GetFiles(getcwd(), g:file_types)
return a:arg == '' ? l:files : matchfuzzy(l:files, a:arg) 
endfunc 

let g:files = []

syntax on

func! _GetFiles(path, file_types)
if !len(g:files)
let g:files = MyCacheLoad(a:path, a:file_types)
endif
return g:files
endfunc

func! MyCacheLoad(path, file_types) 
let l:files = []
for type in split(a:file_types, ',')
let l:files += globpath(a:path, '**/*.' . type, 1, 1) 
endfor
call filter(l:files, '!isdirectory(v:val)') 
call map(l:files, "fnamemodify(v:val, ':.')") 
return l:files
endfunc 

func! HighligtWordUnderCursor()
set hls
call setreg('/', '\<' . expand('<cword>') . '\>')
endfunc

nnoremap - :call HighligtWordUnderCursor()<CR>

nnoremap _ :set hls!<CR>

set showcmd
set incsearch
set hls
set foldmethod=marker

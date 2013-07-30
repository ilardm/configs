set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
"Bundle 'tpope/vim-rails.git'
Bundle 'flazz/vim-colorschemes'
Bundle 'The-NERD-tree'
Bundle 'The-NERD-Commenter'
Bundle 'Tagbar'
Bundle 'JSON.vim'
Bundle 'Markdown'
Bundle 'project.tar.gz'
Bundle 'grep.vim'
Bundle 'clang-complete'
"Bundle 'Vim-JDE'
"Bundle 'javacomplete'
Bundle 'HTML-AutoCloseTag'
Bundle 'xmledit'
Bundle 'buffet.vim'
Bundle 'jelera/vim-javascript-syntax'
Bundle 'myhere/vim-nodejs-complete'
Bundle 'scrooloose/syntastic'
Bundle 'ervandew/supertab'
Bundle 'Solarized'
" vim-scripts repos
"Bundle 'L9'
"Bundle 'FuzzyFinder'
" non github repos
"Bundle 'git://git.wincent.com/command-t.git'
" ...

filetype plugin indent on     " required!
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..

" === customization ==========================================================
au! BufWritePost .vimrc source ~/.vimrc " reload ~/.vimrc after modified
set ttyfast
set enc=utf-8
set dir=~/.vim/swp                  " create .swp files there
set nobackup
syntax on
"set t_Co=256
"colorscheme xoria256                " won't work in tmux :(
colorscheme wuye
set ls=2                            " always show status line
" filename modified? <separator> filetype EOLmode
" encoding
" current spellchek language
" column line totallines
set statusline=%t\ %m\ %=\ (%{strftime('%F\ %I:%M\ %p')})\ %y\ [%{&ff}]\ 
set statusline+=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\"}\ 
set statusline+=%{(&spell?\"[\".&spelllang.\"]\ \":'')}
set statusline+=[%c-%l/%L]
" should be off in order to use tags file in the top-level project directory
"set autochdir                       " auto-change CWD
set incsearch						" search-as-I-type
set ignorecase                      " ignore case on search
set smartcase                       " but use it sometime
set nowrap							" do not wrap long lines
set tabstop=4
set shiftwidth=4
set expandtab						" spaces instead of tabs
set backspace=indent,eol,start
set copyindent
set number							" show line numbers
set cursorline                      " where I am?
hi LineNr NONE						" do not underline 'em

if has( "gui_running" )
    set guifont=DejaVu\ Sans\ Mono\ 10
    set guioptions=m

    "set background=dark
    "colorscheme solarized
    colorscheme zenburn
endif

nmap ZZ :cq<cr>                     " fast quit
nmap <F2> :w<cr>                    " fast save

" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt+=longest,preview
set wildmenu

" highlight long strings
:highlight col81 ctermbg=blue
:match col81 /\%<82v.\%>81v/

" old-good C for headers
au BufRead,BufNewFile *.h set filetype=c

" --- tagbar -------------------------------------------------------------------
nmap <F11> :TagbarToggle<cr>
let g:tagbar_autoclose=1

" --- ctags --------------------------------------------------------------------
nmap <leader>ct :!ctags -R --exclude=build/ .<cr>
set tags+="./tags"

" --- NERDTree -----------------------------------------------------------------
nmap <C-\> :NERDTreeToggle<cr>
nmap <leader><F7> :call NERDTreeAddNode()<cr>
nmap <leader><F8> :call NERDTreeDeleteNode()<cr>
nmap <leader><F6> :call NERDTreeMoveNode()<cr>
nmap <leader><F5> :call NERDTreeCopyNode()<cr>
let NERDTreeChDirMode=2

" --- project  -----------------------------------------------------------------
nmap <F12> <Plug>ToggleProject

" --- grep ---------------------------------------------------------------------
nmap <leader>g :Rgrep<cr>

" --- clangcomplete  -----------------------------------------------------------
let g:clang_auto_select=1           " select first, but not insert
" do not open error window -- syntastic handle this
"let g:clang_complete_copen=1        " open error window
let g:clang_close_preview=1         " close preview
"let g:clang_complete_macros=1       " macro completion
let g:clang_complete_auto=0         " let me type AFAIR

"" --- javacomplete -------------------------------------------------------------
"au Filetype java setlocal omnifunc=javacomplete#Complete
"au Filetype java setlocal completefunc=javacomplete#CompleteParamsInfo
"au Filetype java call javacomplete#AddClassPath(expand('%:p:h'))
"au Filetype java call javacomplete#AddSourcePath(expand('%:p:h'))

" --- supertab -----------------------------------------------------------------
let g:SuperTabDefaultCompletionType="context"
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabContextDiscoverDiscovery = ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]

" --- buffet -------------------------------------------------------------------
nmap <C-w>w :Bufferlist<cr>

" --- json  --------------------------------------------------------------------
au BufRead,BufNewFile *.json set filetype=json
au FileType json set tabstop=2
au FileType json set shiftwidth=2

" --- xml ----------------------------------------------------------------------
au FileType xml,xsd set tabstop=2
au FileType xml,xsd set shiftwidth=2

" --- syntastic ----------------------------------------------------------------
let g:syntastic_check_on_open=1     " check right after file open
let g:syntastic_auto_loc_list=1     " open and keep error window until no errors
let g:syntastic_loc_list_height=5   " make error window little less intrusive
nmap <silent> <S-F7> :silent SyntasticCheck<cr>
nmap <C-w>e :Errors<cr>             " open errors list

let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_config_file = '.clang_complete'
let g:syntastic_c_compiler = 'clang'
let g:syntastic_c_config_file = '.clang_complete'

" --- JavaScript ---------------------------------------------------------------
let g:syntastic_javascript_checker="jshint"

" --- markdown -----------------------------------------------------------------
au! BufNewFile,BufRead *.{md,mkd,mkdn,mark*} set filetype=markdown

" --- spellcheck ---------------------------------------------------------------
"  http://vim.wikia.com/wiki/Toggle_spellcheck_with_function_keys
" for correct processing put dictionaries (.spl .sug) from
" ftp://ftp.vim.org/pub/vim/runtime/spell/ to ~/.vim/spell
let b:myLang=0
let g:myLangList=["nospell","en","ru"]
function! ToggleSpell()
    let b:myLang=b:myLang+1
    if b:myLang>=len(g:myLangList) | let b:myLang=0 | endif
    if b:myLang==0
        setlocal nospell
    else
        "execute "setlocal spell spelllang=".get(g:myLangList, b:myLang)
        execute "setlocal spelllang=".get(g:myLangList, b:myLang)." spell"
    endif
    echo "spell checking language:" g:myLangList[b:myLang]
endfunction

nmap <silent> <F7> :call ToggleSpell()<CR>

" --- C# -----------------------------------------------------------------------
au BufRead,BufNewFile *.config set filetype=xml

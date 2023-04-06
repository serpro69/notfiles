"
" Maintainer:
"       Lars Moelleken
"       http://moelleken.org - lars@moelleken.org
"
" Codebase:
"       Amir Salihefendic
"       http://amix.dk - amix@amix.dk
"
" Version:
"       1.2 - 22/07/16 00:05:00
"
" Sections:
"    -> General
"    -> VIM user interface
"    -> Parenthesis/bracket
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Moving around, tabs and buffers
"    -> Status line
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"    -> Load extra user-config
"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Make Vim more useful.
set nocompatible

" Set the default shell.
set shell=bash

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Tell vim to use the .vim path first.
set runtimepath=~/.vim,$VIMRUNTIME

" Remove ALL autocommands for the current group.
" http://vimdoc.sourceforge.net/htmldoc/autocmd.html
if has('autocmd')
  :au! * <buffer>
endif

" Change leader to a comma because the backslash is too far away
" That means all \x commands turn into ,x
" The mapleader has to be set before vundle starts loading all
" the plugins.
let mapleader = ","
let g:mapleader = ","

" Load plugins
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" Sets how many lines of history VIM has to remember.
set history=100

" Open max 50 tabs.
set tabpagemax=50

if v:version >= 500
  " try reducing the number of lines stored in a register
  set viminfo='500,f1,:100,/100
endif

" Optimize for fast terminal connections.
set ttyfast

" Necessary for gnu screen & mouse.
set ttymouse=xterm2

" Add the g flag to search/replace by default.
set gdefault

" Disable modelines as a security precaution
set modelines=0
set nomodeline

" Ignore whitespace in vimdiff.
if &diff
  set diffopt+=iwhite
endif

" Enable filetype detection.
filetype on

" Enable filetype-specific plugins.
filetype plugin on

" Enable filetype-specific indenting.
filetype indent on

" Decrease timeout for faster insert with 'O'.
set ttimeoutlen=100

" Set extra options when running in GUI mode.
if has("gui_running")
  set guioptions-=T
  set guioptions-=e
  set guitablabel=%M\ %t
endif

" Try to set right locale.
try
  lang en_US
catch
endtry

" Set encoding.
if has('multi_byte')
  scriptencoding utf-8
  set encoding=utf-8
  set fileencodings=utf-8,cp932,sjis,utf-16le,euc-jp

  if has("win32") || has("win64")
    set termencoding=gbk
  endif
  if has("linux") || has("unix")
    set termencoding=utf-8
  endif
endif

" None word dividers.
set isk+=_,$,@,%,#,-

" Try to detect file formats.
" Unix for new files and autodetect for the rest.
set fileformats=unix,dos,mac

" Enable per-directory .vimrc files.
set exrc

" Disable unsafe commands.
set secure

" Disable the splash screen (and some various tweaks for messages).
set shortmess=aTItoO

" Tell us about changes.
set report=0

" Show the filename in the window titlebar.
if exists("+title")
  set title
endif

" Automatically set/unset Vim's paste mode when you paste.
" (https://coderwall.com/p/if9mda)
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

" Allow virtual edit in visual block.
set virtualedit=block

" Specify the behavior when switching between buffers.
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files. (You want this!)
if has('viminfo')
  if has('autocmd')
     autocmd BufReadPost *\(.git/COMMIT_EDITMSG\)\@<!
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
  endif
  " Remember info about open buffers on close.
  set viminfo^=%
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Enhance command-line completion.
if exists("+wildmenu")
  set wildmenu
  " type of wildmenu
  set wildmode=longest:full,list:full
endif

" Completion (text) settings.
set completeopt=longest,menuone

" Ignore compiled files.
set wildignore=*.o,*~,*.pyc
if has("win32") || has("win64")
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
  set wildignore+=.git\*,.hg\*,.svn\*
endif

" Height of the command bar.
set cmdheight=1

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

" Allow cursor keys in insert mode.
set esckeys

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

" Simple toggle for "paste" & "nopaste".
set pastetoggle=<F2>

" Free the cursor.
set whichwrap=b,s,h,l,<,>,[,]

" Ignore case when searching.
set ignorecase

" Use intelligent case while searching.
" (If search string contains an upper case letter, disable ignorecase.)
set smartcase

" Makes search act like search in modern browsers.
if exists("+incsearch")
  set incsearch
endif

" Don't redraw while executing macros (good performance config)
"
" disabled: https://github.com/voku/dotfiles/issues/22#issuecomment-234516390
"
" set lazyredraw

" For regular expressions turn magic on.
set magic

" Split vertically to the right.
set splitright

" Split horizontally below.
set splitbelow

" Do not reset cursor to start of line when moving around.
set nostartofline

" Show the cursor position.
if exists("+ruler")
  set ruler
endif

" Start scrolling at this number of lines from the bottom.
set scrolloff=2

" Start scrolling three lines before the horizontal window border.
set scrolloff=3

" Start scrolling horizontally at this number of columns.
set sidescrolloff=4

" Disable line numbers (left).
set nonumber

" No annoying sound on errors.
set noerrorbells
set visualbell

" No extra margin to the left.
set foldcolumn=0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parenthesis/bracket
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Show matching brackets when text indicator is over them.
set showmatch

" Include angle brackets in matching.
set matchpairs+=<:>

" How many tenths of a second to blink when matching brackets.
set mat=2


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Switch syntax highlighting on, when the terminal has colors.
if &t_Co > 2 || has("gui_running")
  try
    colorscheme molokai
  catch /^Vim\%((\a\+)\)\=:E185/
    " not available
  endtry

  " Visual line marking 80 characters (vim 7.3).
  if v:version >= 703
    set textwidth=80
    set colorcolumn=+1
  endif

  " Enable coloring for dark background terminals.
  if has('gui_running')
    set background=light
  else
    set background=dark
  endif

  " Turn on color syntax highlighting.
  if exists("+syntax")
    syntax on
    " increases syntax accuracy
    syntax sync fromstart
  endif

  " Also switch on highlighting the last used search pattern.
  if exists("+hlsearch")
    set hlsearch
  endif

  " Highlight current line.
  if exists("+cursorline")
    set cursorline
  endif

  " Highlight trailing spaces in annoying red.
  if has('autocmd')
    highlight ExtraWhitespace ctermbg=1 guibg=red
    match ExtraWhitespace /\s\+$/
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    if exists('*clearmatches')
      autocmd BufWinLeave * call clearmatches()
    endif
  endif

  " Reload .vimrc when saving it.
  if has("autocmd")
    autocmd BufWritePost .vimrc nested source %
  endif

  " Highlight conflict markers.
  match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Strip trailing whitespaces automatically when saving files of certain type.
if has("autocmd")
  autocmd BufWritePre *.py,*.js,*.php,*.gpx,*.rb,*.tpl :call StripTrailingWhitespaces()
endif

" Keep a backup-file.
set backup
if exists("+writebackup")
  set writebackup
  set backupdir=~/.vim/backups
endif

" Centralize backups, swapfiles and undo history.
set directory=~/.vim/swaps
if exists("+undodir")
  set undodir=~/.vim/undo
endif

" Don't backup files in temp directories or shm.
if exists('&backupskip')
  set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
endif

" Don't keep swap files in temp directories or shm.
if has('autocmd')
  augroup swapskip
    autocmd!
    silent! autocmd BufRead,BufNewFilePre
      \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
      \ setlocal noswapfile
  augroup END
endif

" Don't keep undo files in temp directories or shm.
if has('persistent_undo') && has('autocmd')
 augroup undoskip
   autocmd!
   silent! autocmd BufWritePre
     \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
     \ setlocal noundofile
  augroup END
endif

" Don't keep viminfo for files in temp directories or shm.
if has('viminfo')
  if has('autocmd')
    augroup viminfoskip
      autocmd!
      silent! autocmd BufRead,BufNewFilePre
        \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
        \ setlocal viminfo=
    augroup END
  endif
endif

" Enable vim to remember undo chains between sessions (vim 7.3).
if v:version >= 703
  set undofile
endif

" disable folding
set nofoldenable


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Expand tabs to spaces.
set expandtab

" Insert spaces for tabs according to shiftwidth.
if exists("+smarttab")
  set smarttab
endif

" Does nothing more than copy the indentation from the previous line,
" when starting a new line.
if exists("+autoindent")
  set noautoindent
endif

" Automatically inserts one extra level of indentation in some cases.
if exists("+smartindent")
  set smartindent
endif

" 1 tab === 2 spaces
set shiftwidth=2
set tabstop=2

" Number of spaces to use for each step of indent.
set shiftwidth=2
set softtabstop=2

" Use one space, not two, after punctuation.
set nojoinspaces

" Don't automatically wrap text when typing.
set fo-=t

" Set characters to show for trailing whitespace and
" end-of-line. Also supports tab, but I set expandtab
" and thus tabs are always turned into spaces.
set listchars=tab:>>,trail:!,eol:$

" Support for numbered/bullet lists.
set formatoptions+=n


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" gi moves to last insert mode (default)
" gI moves to last modification
nnoremap gI `.

" Movement & wrapped long lines.
nnoremap j gj
nnoremap k gk

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search).
map <space> /
map <C-space> ?

" Disable highlight when <leader><cr> is pressed.
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows.
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer.
map <leader>bd :Bclose<cr>

" Close all the buffers.
map <leader>ba :1,1000 bd!<cr>

" Useful mappings for managing tabs.
nnoremap <C-S-Left> :tabprevious<cr>
nnoremap <C-S-Right> :tabnext<cr>
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove<cr>

" Opens a new tab with the current buffer's path.
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer.
map <leader>cd :cd %:p:h<cr>:pwd<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Always show the status line.
set laststatus=2

" Show current mode in the status line.
if exists("+showmode")
  set showmode
endif

" Show the (partial) command as it’s being typed.
if exists("+showcmd")
  set showcmd
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File Types
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" automatic commands
if has("autocmd")
  " file type detection

  " Ruby
  au BufRead,BufNewFile *.rb,*.rbw,*.gem,*.gemspec set filetype=ruby

  " Ruby on Rails
  au BufRead,BufNewFile *.builder,*.rxml,*.rjs     set filetype=ruby

  " Rakefile
  au BufRead,BufNewFile [rR]akefile,*.rake         set filetype=ruby

  " Rantfile
  au BufRead,BufNewFile [rR]antfile,*.rant         set filetype=ruby

  " IRB config
  au BufRead,BufNewFile .irbrc,irbrc               set filetype=ruby

  " eRuby
  au BufRead,BufNewFile *.erb,*.rhtml              set filetype=eruby

  " Thorfile
  au BufRead,BufNewFile [tT]horfile,*.thor         set filetype=ruby

  " css - preprocessor
  au BufRead,BufNewFile *.less,*.scss,*.sass       set filetype=css syntax=css

  " gnuplot
  au BufRead,BufNewFile *.plt                      set filetype=gnuplot

  " C++
  au BufRead,BufNewFile *.cpp                      set filetype=cpp

  " markdown
  au BufRead,BufNewFile *.md,*.markdown,*.ronn     set filetype=markdown

  " special text files
  au BufRead,BufNewFile *.rtxt         set filetype=html spell
  au BufRead,BufNewFile *.stxt         set filetype=markdown spell

  au BufRead,BufNewFile *.sql        set filetype=pgsql

  au BufRead,BufNewFile *.rl         set filetype=ragel

  au BufRead,BufNewFile *.svg        set filetype=svg

  au BufRead,BufNewFile *.haml       set filetype=haml

  " aura cmp files
  au BufRead,BufNewFile *.cmp        set filetype=html

  " JavaScript
  au BufNewFile,BufRead *.es5        set filetype=javascript
  au BufNewFile,BufRead *.es6        set filetype=javascript
  au BufRead,BufNewFile *.hbs        set syntax=handlebars
  au BufRead,BufNewFile *.mustache   set filetype=mustache
  au BufRead,BufNewFile *.json       set filetype=json syntax=javascript

  " zsh
  au BufRead,BufNewFile *.zsh-theme  set filetype=zsh

  au Filetype gitcommit                setlocal tw=68 spell fo+=t nosi
  au BufNewFile,BufRead COMMIT_EDITMSG setlocal tw=68 spell fo+=t nosi

  " ruby
  au Filetype ruby                   set tw=80

  " allow tabs on makefiles
  au FileType make                   setlocal noexpandtab
  au FileType go                     setlocal noexpandtab

  " set makeprg(depends on filetype) if makefile is not exist
  if !filereadable('makefile') && !filereadable('Makefile')
    au FileType c                    setlocal makeprg=gcc\ %\ -o\ %<
    au FileType cpp                  setlocal makeprg=g++\ %\ -o\ %<
    au FileType sh                   setlocal makeprg=bash\ -n\ %
    au FileType php                  setlocal makeprg=php\ -l\ %
  endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Fast saving, via shortcuts.
nmap <leader>w :w<cr>
nmap <leader>q :q<cr>

" Visual mode pressing * or # searches for the current selection.
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>

" Remap VIM 0 to first non-blank character.
map 0 ^

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" Yank and put system pasteboard with <Leader>y/p.
noremap <Leader>y "*y
noremap <Leader>Y "*y$
nnoremap <Leader>yy "*yy
noremap <Leader>p "*p
noremap <Leader>P "*P

" Show current file as HTML. (to paste into Keynote)
nmap <Leader>h :TOhtml<CR>:w<cr>:!open %<CR>:q<CR>

" Select all.
map <Leader>a ggVG

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac.
nmap <c-s-Down> mz:m+<cr>`z
nmap <c-s-Up>   mz:m-2<cr>`z
vmap <c-s-Down> :m'>+<cr>`<my`>mzgv`yo`z
vmap <c-s-Up>   :m'<-2<cr>`>my`<mzgv`yo`z

" Copy between different vim sessions.
"
" disabled: "Do not map S-P, paste before" via DrVanScott
"
"nmap <s-Y> :!echo “”> ~/.vim/tmp<CR><CR>:w! ~/.vim/tmp<CR>
"vmap <s-Y> :w! ~/.vim/tmp<CR>
"nmap <s-P> :r ~/.vim/tmp<CR>

if has("mac") || has("macunix")
  nmap <D-j> <c-s-Down>
  nmap <D-k> <c-s-Up>
  vmap <D-j> <c-s-Down>
  vmap <D-k> <c-s-Up>
endif

" map F7 to syntax-check
map <F7> :make <CR>

" Emacs movement keybindings in insert mode.
"
" disabled: "Do not map C-a. killer feature in normal/input mode" via DrVanScott
"
"imap <C-a> <C-o>0
"imap <C-e> <C-o>$
"map <C-e> $
"map <C-a> 0

" Stop opening man pages.
nmap K <nop>

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" strip whitespace (,sw)
noremap <leader>sw :call StripWhitespace()<CR>
" save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <s-tab> <C-n>
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' : '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Use 'ack' instead of Grep when available.
if executable("ack")
  set grepprg=ack\ -H\ --nogroup\ --nocolor\ --ignore-dir=tmp\ --ignore-dir=coverage
endif

" When you press gv you Ack after the selected text.
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" Open Ack and put the cursor in the right position.
map <leader>g :Ack

" When you press <leader>r you can search and replace the selected text.
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Pressing ,ss will toggle and untoggle spell checking.
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>.
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remove the Windows ^M - when the encodings gets messed up.
"
" -> ,m
"
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble.
"
" -> ,q
"
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble.
"
" -> ,x
"
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off. (you can also use <F2>)
"
" -> ,pp
"
map <leader>pp :setlocal paste!<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" Toggle between number and relativenumber.
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" Stripe whitespace.
function! StripWhitespace()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  :%s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction

" Multi-purpose tab key. (auto-complete)
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<Tab>"
  else
    return "\<C-p>"
  endif
endfunction

" Strip trailing whitespace.
function! StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

function! CmdLine(str)
  exe "menu Foo.Bar :" . a:str
  emenu Foo.Bar
  unmenu Foo
endfunction

function! VisualSelection(direction, extra_filter) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  elseif a:direction == 'gv'
    call CmdLine("Ack \"" . l:pattern . "\" " )
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
  elseif a:direction == 'f'
    execute "normal /" . l:pattern . "^M"
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

" Do not close window, when deleting a buffer.
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => load extra user-config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if filereadable($HOME . "/.vimrc.extra")
  source ~/.vimrc.extra
endif

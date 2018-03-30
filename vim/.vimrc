" Andy Wong's VIMRC File <awong@comscore.com> 
"
" References 
" - An example for a vimrc by Bram Moolenaar
" - A Good .vimrc by Doug Black
"   https://dougblack.io/words/a-good-vimrc.html
" - Learn VIM script the hard way
"   http://learnvimscriptthehardway.stevelosh.com
" - VIM Bootstrap
"   http://vim-bootstrap.com
" - Awesome VIMRC
"   https://github.com/amix/vimrc

set nocompatible            " include vim only settings/features

"source $VIMRUNTIME/mswin.vim
"behave mswin

" Load all installed plugins using Pathogen
execute pathogen#infect()

set shell=/bin/bash
"func! PowershellSetup()
"  set shell=powershell\ -ExecutionPolicy\ Unrestricted\ -NoProfile
"  set shellcmdflag=-command
"  set shellquote=\"
"  set shellxquote=\"
"endfu

func! CommonSetup()
  set wildmenu              " visual autocomplete for command menu 
  set wildmode=longest,list " longest name, then list all combinations
  set noeb                  " no bell
  set visualbell            " blink cursor rather than beep
  set lazyredraw            " redraw only when needed
  set showmatch             " highlight matching [{()}]
  set incsearch             " search as characters are entered

  " Switch syntax highlighting on, when the terminal has colors
  " Also switch on highlighting the last used search pattern.
  if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
  endif
  set encoding=utf-8        " set encoding to utf-8
  set ignorecase            " case-insensitive searching
  set smartcase             " do not be case-insensitive searching when search phrase has upper case
  set showmode              " show whether in insert mode
  set scrolloff=3           " Always display 3 lines of context top/bottom
  set laststatus=1          "
  set autochdir             " Change directory

  " Don't use Ex mode, use Q for formatting
  map Q gq

  " CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
  " so that you can undo CTRL-U after inserting a line break.
  inoremap <C-U> <C-G>u<C-U>

  set history=50		        " keep 50 lines of command line history
  " allow backspacing over everything in insert mode
  set backspace=indent,eol,start

  if has("vms")
    set nobackup		" do not keep a backup file, use versions instead
  else
    set backup		" keep a backup file (restore to previous version)
    set undofile		" keep an undo file (undo changes after closing)
  endif

  " Short cut for working with VIM settings
  :let mapleader = "\\" " set global leader key
  nnoremap <leader>wv :echo $MYVIMRC<cr>
  nnoremap <leader>ev :vsplit $MYVIMRC<cr>
  nnoremap <leader>sv :source $MYVIMRC<cr>

  " CTRL + t to open a new tab
  nnoremap <C-t> :tabnew<CR>

  " In many terminal emulators the mouse works just fine, thus enable it.
  if has('mouse')
    set mouse=a
  endif
endfu

func! SetUpAbbreviations()
  iabbrev waht what
  iabbrev tehn then
  iabbrev @@    awong@comscore.com
  iabbrev ccopy Copyright 2017 Comscore, all rights reserved.
endfu

function! MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

set diffexpr=MyDiff()

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif

" TODO: add autocorrect function
func! WordProcessorMode()
  filetype off
  filetype plugin off
  filetype indent off " turn off filetype-specific indent files
  nnoremap j gj       " move vertically by visual line
  nnoremap k gk       " move vertically by visual line
  setlocal formatoptions=t1
  setlocal wrap
  setlocal linebreak
  setlocal textwidth=80
  setlocal smartindent
  setlocal spell spelllang=en_us
  set formatoptions=aw2tq
  set foldcolumn=12
  nnoremap \s eas<C-X><C-S>
  setlocal tabstop=4 "number of visual spaces per tab
  setlocal softtabstop=4 "number of spaces in tab when editing
  setlocal noexpandtab
  setlocal nonumber "no line numbers
  setlocal noruler "do not show file stats
  setlocal noshowcmd "do not show command in bottom bar
  setlocal nohlsearch
  setlocal nocursorline
  setlocal nocursorcolumn
  set complete+=s
  set formatprg=par
  set guioptions-=r " Remove right sidebar
  set guioptions-=L " Remove left sidebars
  set guicursor=a:blinkon0 " Set cursor to not blink

  syntax off
  colorscheme elflord
  set background=light
  if has("gui_running")
    " Only use light background in the UI, in console it is really ugly
    set guioptions-=T " no toolbar
    if has("gui_gtk2")
      set guifont=Inconsolata\ 12
    elseif has("gui_macvim")
      set guifont=Menlo\ Regular:h14
    elseif has("gui_win32")
      set guifont=Courier:h10:cANSI
    endif
  endif
endfu
com! WP call WordProcessorMode()

func! VSCodeMode()
  filetype on
  filetype plugin on 
  filetype indent on "turn on filetype-specific indent files
  filetype indent on "turn on filetype-specific indent files
  set tabstop=2 "number of visual spaces per tab
  set softtabstop=2 "number of spaces in tab when editing
  set shiftwidth=2
  set shiftround
  set expandtab "tabs are spaces
  set nocursorline "highlight current line
  set nocursorcolumn "highlight current column
  nnoremap j j
  nnoremap k k
  setlocal formatoptions=t1
  "setlocal formatoptions=cq1
  set foldenable
  set foldmethod=indent
  set foldcolumn=1
  " set foldcolumn=0
  set foldlevel=5
  set hlsearch
  set nowrap

  setlocal textwidth=79
  setlocal smartindent
  setlocal nospell "no spell checking when editing code
  setlocal expandtab
  setlocal number "show line numbers
  setlocal ruler "show file stats
  setlocal showcmd "show command in bottom bar

  syntax enable
  colorscheme delek
  set background=dark

  "GUI to mimic for Visual Studio Code default font settings
  if has("gui_running")
    set guioptions-=T " no toolbar
    if has("gui_gtk2")
      set guifont=Schumacher\ Clean
    elseif has("gui_macvim")
      set guifont=Menlo\ Regular:h14
    elseif has("gui_win32")
      set guifont=Consolas:h10:cANSI
    endif
  endif
endfu
com! CM call VSCodeMode()

call CommonSetup()
call SetUpAbbreviations()
"call PowershellSetup()
call VSCodeMode()

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END
else
  set autoindent		" always set autoindenting on
endif " has("autocmd")

augroup filetypedetect 
  au BufNewFile,BufRead *.pig set filetype=pig syntax=pig 
augroup END 

" Automatically cd into the directory that the file is in
autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

"Open NERDTree on start up
autocmd vimenter * NERDTree 

" Close vim window if only window left is nerdtree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

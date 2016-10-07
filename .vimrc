" An example for a vimrc file.
" __CLEMENT_BENIER__
"

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  set undofile		" keep an undo file (undo changes after closing)
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

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
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

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

"Vundle setup
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'Lokaltog/vim-powerline'
" vim-scripts repos
Bundle 'L9'
Bundle 'taglist.vim'
Bundle 'FuzzyFinder'
Bundle 'OmniCppComplete'
Bundle 'Valloric/YouCompleteMe'
Bundle 'scrooloose/nerdtree'
Bundle 'Command-T'
Bundle 'The-NERD-tree'
" non github repos
"Bundle 'git://git.wincent.com/command-t.git'
" ...

let Tlist_Ctags_Cmd = '/usr/bin/ctags'
filetype on


filetype plugin indent on " required!
set omnifunc=syntaxcomplete#Complete
"
" Brief help
" :BundleList - list configured bundles
" :BundleInstall(!) - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!) - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed.

""VIMRC MINIMAL ENSIWIKI
syn  on
set  syntax =on
filetype  plugin indent on
set  nocp
set  nu "numero lignes
set  showmatch "parenthèses correspondantes
set  guifont =Courier\ 12 " Modifier la police
"modifier tabulation
set  tabstop =4
set  shiftwidth =4
set  softtabstop =4
set  expandtab    "supprime les tabulations et met des espaces
set  incsearch " Afficher les résultats de la recherche au moment de la saisie
" Recherche sensible à la casse, ou pas, ou un peu
set  ignorecase
set  smartcase
" Afficher les possibilités lors de la complétion
set  wildmenu    "affiche le menu
set  wildmode =list:longest,list:full    "affiche toutes les possibilités
set  wildignore =*.o,*.r,*.so,*.sl,*.tar,*.tgz    "ignorer certains types de fichiers pour la complétion des includes

" Auto folding des fonctions
"function! MyFoldFunction()
"	let line = getline(v:foldstart)
"	let sub = substitute(line,'/\*\|\*/\|^\s+', '', 'g')
"	let lines = v:foldend - v:foldstart + 1
"	return v:folddashes.sub.'...'.lines.' Lines...'.getline(v:foldend)
"endfunction
"
"set  foldmethod =syntax    "Réduira automatiquement les fonctions et blocs
"(#region en C# par exemple)
"set  foldtext =MyFoldFunction()    "on utilise notre fonction (optionnel)

" Vim correcteur orthographique
""set  spelllang =en,fr
""set  spell
""set  spellsuggest =5
" Afficher la ligne contenant le curseur
set  cursorline
set t_Co=256
colorscheme mustang

let mapleader = ","

map <silent> <F7> "<Esc>:silent setlocal spell! spelllang=en <CR>"
map <silent> <F8> "<Esc>:silent set ft=dokuwiki list<CR>"

let g:languagetool_jar='$HOME/work/software/languagetool/1.5/LanguageTool.jar'

"abreviations:
ia intmain int main(int argc, char **argv){<CR><CR>return 0;<CR>}<UP><UP>
ia <b <code bash><CR><CR></code><UP>
ia <c <code c><CR></code><UP>
ia <o <code c>
ia <e </code><CR>
ia dok_ //**____**//<left><left><left><left><left><left>
":ia { {<CR>}<UP>
":ia ( ()<left>

"mutt
autocmd BufRead ~/.mutt/tmp/mutt* set textwidth=72 "spell
autocmd BufNewfile,BufRead ~/.mutt/tmp/mutt*[0-9] set nobackup nowritebackup

set noeol
autocmd BufWritePre * :%s/\s\+$//e
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
nnoremap <leader>$  :'<,'>s/$/                                                 /e<CR>

""desactiver les touches
map <DOWN> <Esc>
map <UP> <Esc>
map <LEFT> <Esc>
map <RIGHT> <Esc>
imap <DOWN> <Esc>
imap <UP> <Esc>
imap <LEFT> <Esc>
imap <RIGHT> <Esc>
""space into _
nnoremap <leader>_ :s/<SPACE>/_/g<CR> /zz<CR>

""tab sizes
nnoremap <leader>3 :set softtabstop=3 tabstop=3 shiftwidth=3<CR>
nnoremap <leader>4 :set softtabstop=4 tabstop=4 shiftwidth=4<CR>
nnoremap <leader>k {
nnoremap <leader>j }
nnoremap <leader>n :tabprev<CR>
nnoremap <leader>; :tabnext<CR>
nnoremap <leader>t :NERDTree<CR>
set colorcolumn=80

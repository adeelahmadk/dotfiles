" *******************************************
"        Advanced Code Editor: ACE vim
" *******************************************

" Need to be the first line.
set nocompatible
filetype off

"==========================================
""	 Package Manager Settings
"==========================================

" Install vundle, a vim bundle manager
"  mkdir -p ~/.vim/bundle
"  git clone https://github.com/gmarik/Vundle.vim ~/.vim/bundle/Vundle.vim

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" ----- Making Vim look good -----------------------------------------
" To make Vim look good, you can install extra color schemes.
" Download patched font from  https://github.com/abertsch/Menlo-for-Powerline
" cp Menlo\ for\ Powerline.ttf ~/.fonts
" fc-cache -vf ~/.fonts
" change your font in your terminal emulator.
Plugin 'altercation/vim-colors-solarized'
Plugin 'tomasr/molokai'
" Adds tons of information to your Vim statusbar.
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" ----- Vim as a programming text editor ------------------------------
" Let you view your project's files in a sidebar
" Sidebar Toggle: <leader>t
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
" Error checking for just about every language imaginable right from within Vim 
" https://github.com/scrooloose/syntastic
Plugin 'scrooloose/syntastic'
" Give you the power to see what kinds of methods, variables,
" functions, and other types of declarations you have in your files.
" Dependency: Exuberant Ctags
" On Debian repos: apt-get install exuberant-ctags
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
" Full path fuzzy file, buffer, mru, tag, ... finder for Vim.
" https://github.com/ctrlpvim/ctrlp.vim
Plugin 'kien/ctrlp.vim'
" A plugin for opening header files automatically.
" Simply type :AT to open up the alternate file (i.e., cache.h for cache.c)
" For advanced plugin, check https://github.com/tpope/vim-projectionist
Plugin 'vim-scripts/a.vim'

" ----- Working with Git ----------------------------------------------
" Shows a +/-/~ next to lines that have been added, removed,
" and modified, and other interesting info in vim-airline's statusbar.
Plugin 'airblade/vim-gitgutter'
" Makes working with Git from within Vim incredibly easy.
" Commands:
" - git add                  --> :Gwrite
" - git commit               --> :Gcommit
" - git push                 --> :Gpush
" - git checkout <file name> --> :Gread
" - git blame                --> :Gblame
" - ... many more on https://github.com/tpope/vim-fugitive
Plugin 'tpope/vim-fugitive'

" ----- Other text editing features -----------------------------------
"  Inserts matching delimiters, like quotes, parentheses, and curly braces,
"  automatically.
"  Detailed feature list on: https://github.com/jiangmiao/auto-pairs
Plugin 'jiangmiao/auto-pairs'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Automatically reload .vimrc
" autocmd! bufwritepost .vimrc source %

"==========================================
""	 General Settings
"==========================================
syntax on

set backspace=indent,eol,start
set number  " show line numbers
set ruler
set showcmd
set nowrap  " don't automatically wrap on load
set fo-=t   " don't automatically wrap text when typing

" Make seaarch case insensitive
set incsearch
set hlsearch
set ignorecase
set smartcase

" Useful settings
set history=700
set undolevels=700

" Real programmers don't use TABs but spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab

set mouse=a

" Show whitespace
" MUST be inserted BEFORE the colorscheme command
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au InsertLeave * match ExtraWhitespace /\s\+$/

" Rebind <Leader> key to ``,`` that is next to ``m`` and ``n``, used for tab navigation.
let mapleader = ","

" Bind nohl
" Removes highlight of your last search
noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>


" Quicksave command
noremap <C-Z> :update<CR>
vnoremap <C-Z> <C-C>:update<CR>
inoremap <C-Z> <C-O>:update<CR>

" Quick quit command
noremap <Leader>e :quit<CR>  " Quit current window
noremap <Leader>E :qa!<CR>   " Quit all windows

" Indent code blocks
" Go into visual mode (v), select several lines of code,
" then press ``>`` to indent.
vnoremap < <gv  " - indentation
vnoremap > >gv  " + indentation

" Bind Ctrl+<movement> keys to move among the windows
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Easy navigations among tabs
map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>

" Disable stupid backup and swap files - they trigger too many events
" for file system watchers
"" set nobackup
"" set nowritebackup
"" set noswapfile


"==========================================
""	 Plugin Settings
"==========================================

" ----- altercation/vim-colors-solarized settings -----
" Toggle this to "light" for light colorscheme
set background=dark

" Uncomment the next line if your terminal is not configured for solarized
""let g:solarized_termcolors=256
""let g:molokai_original = 1

" Set the colorscheme
""colorscheme molokai
""colorscheme solarized
set t_Co=256
color wombat256mod

" Showing line numbers and length
set tw=79   " width of document (used by gd)
set colorcolumn=80
highlight ColorColumn ctermbg=233


" ----- bling/vim-airline settings -----
" Always show statusbar
set laststatus=2

" Fancy arrow symbols, requires a patched font
" To install a patched font, run over to
"     https://github.com/abertsch/Menlo-for-Powerline
" download all the .ttf files, double-click on them and click "Install"
" Finally, uncomment the next line
let g:airline_powerline_fonts = 1

" Show PASTE if in paste mode
let g:airline_detect_paste=1

" Show airline for tabs too
let g:airline#extensions#tabline#enabled = 1

let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'


" ----- jistr/vim-nerdtree-tabs -----
" Open/close NERDTree Tabs with <leader>t
nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
" To have NERDTree always open on startup
let g:nerdtree_tabs_open_on_console_startup = 0


" ----- scrooloose/syntastic settings -----
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"
augroup mySyntastic
	au!
	au FileType tex let b:syntastic_mode = "passive"
augroup END

" ----- xolox/vim-easytags settings -----
" Where to look for tags files
set tags=./tags;,~/.vimtags
" Sensible defaults
let g:easytags_events = ['BufReadPost', 'BufWritePost']
let g:easytags_async = 1
let g:easytags_dynamic_files = 2
let g:easytags_resolve_links = 1
let g:easytags_suppress_ctags_warning = 1

" ----- majutsushi/tagbar settings -----
" Open/close tagbar with <leader>b
nmap <silent> <leader>b :TagbarToggle<CR>
" Uncomment to open tagbar automatically whenever possible
"autocmd BufEnter * nested :call tagbar#autoopen(0)

" ----- airblade/vim-gitgutter settings -----
" Required after having changed the colorscheme
hi clear SignColumn
" In vim-airline, only display "hunks" if the diff is non-zero
let g:airline#extensions#hunks#non_zero_only = 1

" ----- jiangmiao/auto-pairs settings -----
" Default settings:
" Map <C-h> to delete brackets, quotes in pair
" g:AutoPairsMapCh, Default : 1
" Map <CR> to insert a new indented line
" g:AutoPairsMapCR, Default : 1
" Map <space> to insert a space after the opening character and before the
" closing one
" g:AutoPairsMapSpace, Default : 1
"


vim9script 

augroup vimOptions
  autocmd!
augroup END

# netrw
g:netrw_list_hide = ',^\.\=/\=$'
g:netrw_banner = 0
g:netrw_altfile = 1
g:netrw_preview = 1
g:netrw_alto = 0
g:netrw_use_errorwindow = 0
g:netrw_special_syntax = 1
g:netrw_cursor = 0

autocmd vimOptions FileType netrw nmap <buffer> . mfmx

def g:Ls(): void
  var file = expand('%:t')
  execute 'Explore' expand('%:h')
  search(file, 'wc')
enddef

nnoremap <silent> - :call Ls()<cr>

# options
&t_EI ..= "\e[2 q"
&t_SR ..= "\e[4 q"
&t_SI ..= "\e[6 q"
set t_ut=
set t_md=
set path=.,**
set hidden
set gdefault
set autoread autowrite autowriteall
set noswapfile
set nowritebackup
set undofile undodir=/tmp/,.
set autoindent smartindent
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround
set nostartofline
set nojoinspaces
set nowrap
&showbreak = '↳ '
set breakindent
set breakindentopt=sbr
set termguicolors
set noshowmode
set matchpairs-=<:>
set nrformats-=octal
set number
set mouse=a ttymouse=sgr
set signcolumn=yes
set splitright splitbelow
set fillchars=diff:┄,vert:│
set virtualedit=onemore
set sidescrolloff=10 sidescroll=1
set sessionoptions=buffers,curdir,folds,tabpages,winsize
set lazyredraw
set timeoutlen=3000
set ttimeoutlen=50
set updatetime=100
set incsearch hlsearch
set pumheight=5
set diffopt+=context:3,indent-heuristic,algorithm:patience
set list
set listchars=tab:⍿\ ,trail:·,nbsp:␣,extends:❯,precedes:❮
autocmd vimOptions InsertEnter * set listchars-=trail:⋅
autocmd vimOptions InsertLeave * set listchars+=trail:⋅
set shortmess=asOIc
set confirm
set wildmenu
set wildmode=longest:full,full
set wildoptions=pum
set wildignorecase
set wildcharm=<C-Z>
if executable('rg')
  &grepprg = 'rg --vimgrep'
else
  &grepprg = 'grep -rnHI'
endif
set backspace=indent,eol,start
&laststatus = 2
&statusline = ' %{mode()} | %{expand("%:p:h:t")}/%t %m %r %= %c:%l/%L    %y'

# mappings
nnoremap <silent> <c-w>d :bp<bar>bd#<cr>
nnoremap <silent> <C-w>z :wincmd z<Bar>cclose<Bar>lclose<cr>
cnoremap <c-a> <Home>
cnoremap <c-e> <End>
nnoremap vv viw
xnoremap il g_o^
onoremap il :<C-u>normal vil<cr>
vnoremap . :normal .<cr>
nnoremap <silent> 3<C-g> :echon system('cat .git/HEAD')->split('\n')<cr>
nnoremap <silent> <C-l> :noh<bar>diffupdate<bar>syntax sync fromstart<cr><c-l>
nnoremap [q :cprev<cr>
nnoremap ]q :cnext<cr>

# autocmds
# keep cursor position
autocmd vimOptions BufReadPost * {
  if line("'\"") > 1 && line("'\"") <= line("$") && &filetype != 'gitcommit'
    exe 'normal! g`"'
  endif
  }

# qf and help widows full width
autocmd vimOptions FileType qf,help wincmd J

# update diff
autocmd vimOptions InsertLeave * {
  if &diff
    diffupdate
  endif
  }

# mkdir
autocmd vimOptions BufWritePre * {
  if !isdirectory(expand('%:h', v:true))
    mkdir(expand('%:h', v:true), 'p')
  endif
  }

# filetypes
g:markdown_fenced_languages = ['ruby', 'html', 'js=javascript', 'ts=typescript', 'css', 'sh=bash', 'sh', 'lua', 'vim', 'nix']
autocmd vimOptions BufNewFile,BufReadPost *.md,*.markdown setlocal conceallevel=2 concealcursor=n
autocmd vimOptions BufNewFile,BufReadPost *.gitignore setfiletype gitignore
autocmd vimOptions BufNewFile,BufReadPost .babelrc    setfiletype json
autocmd vimOptions BufNewFile,BufReadPost *.njk       setfiletype htmldjango
autocmd vimOptions BufNewFile,BufReadPost *.txt       setfiletype markdown
autocmd vimOptions BufNewFile,BufReadPost *.json  setlocal conceallevel=0 concealcursor=
autocmd vimOptions BufNewFile,BufReadPost *.json  setlocal formatoptions=
autocmd vimOptions BufNewFile,BufReadPost *.html,*.javascript  setlocal matchpairs-=<:>
autocmd vimOptions BufNewFile,BufReadPost * setlocal formatoptions-=o

# highlight groups
def SynGroup(): void
  const s = synID(line('.'), col('.'), 1)
  echo synIDattr(s, 'name') .. ' -> ' .. synIDattr(synIDtrans(s), 'name')
enddef
command HL SynGroup()

# sessions
const session_path = expand('~/.cache/vim/sessions/')
if !isdirectory(session_path)
  mkdir(session_path, 'p')
endif
autocmd! vimOptions VimLeavePre * {
  execute 'mksession! ' .. session_path .. split(getcwd(), '/')[-1]
  }
command! -nargs=0 SS {
  execute 'source ' .. session_path .. split(getcwd(), '/')[-1]
  }
nnoremap <leader>s :SS<cr>

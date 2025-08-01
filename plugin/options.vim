vim9script 

augroup vimOptions
  autocmd!
augroup END

# netrw
g:netrw_list_hide = '^./$,^../$'
g:netrw_banner = 0
g:netrw_altfile = 1
g:netrw_preview = 1
g:netrw_alto = 0
g:netrw_use_errorwindow = 0
g:netrw_special_syntax = 1
g:netrw_cursor = 0

autocmd vimOptions FileType netrw nmap <buffer> . mfmx

def OpenExploreFindFile()
  const file = expand('%:t')
  execute 'Explore!'
  call search('^' .. file .. '$', 'wc')
enddef

nnoremap - :call <sid>OpenExploreFindFile()<CR>

# options
&t_EI ..= "\e[2 q"
&t_SR ..= "\e[4 q"
&t_SI ..= "\e[6 q"
&t_ut = ''
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
set tildeop
set scrolloff=0
&showbreak = '↳ '
set breakindent
set breakindentopt=sbr
set termguicolors
set noshowmode
set matchpairs-=<:>
set nrformats-=octal
set number
set mouse=a
set cursorline
set cursorlineopt=number
set signcolumn=yes
set splitright splitbelow
set splitkeep=screen
set fillchars=diff:\ ,vert:│
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
set listchars=lead:⋅,trail:⋅,tab:⁚⁚,nbsp:␣,extends:»,precedes:«
autocmd vimOptions InsertEnter * set listchars-=trail:⋅
autocmd vimOptions InsertLeave * set listchars+=trail:⋅
set shortmess+=Ic
set confirm
set wildmenu
set wildmode=longest:full,full
set wildoptions=pum
set wildignorecase
if executable('rg')
  &grepprg = 'rg --color=never --vimgrep'
else
  &grepprg = 'grep -rnHI'
endif
set backspace=indent,eol,start
&laststatus = 2
&statusline = '%{expand("%:p:h:t")}/%t %{&modified?" ":""} %r %= %c:%l/%L    %y'

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
nnoremap <expr> j v:count ? (v:count > 5 ? "m'" .. v:count : '') .. 'j' : 'gj'
nnoremap <expr> k v:count ? (v:count > 5 ? "m'" .. v:count : '') .. 'k' : 'gk'

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

# external changes
autocmd CursorHold * silent! checktime

# filetypes
g:markdown_fenced_languages = ['ruby', 'html', 'js=javascript', 'ts=typescript', 'css', 'sh=bash', 'sh', 'lua', 'vim', 'nix']
autocmd vimOptions BufNewFile,BufReadPost *.md,*.markdown setlocal conceallevel=2 concealcursor=n
autocmd vimOptions BufNewFile,BufReadPost *.gitignore setfiletype gitignore
autocmd vimOptions BufNewFile,BufReadPost .babelrc    setfiletype json
autocmd vimOptions BufNewFile,BufReadPost *.njk       setfiletype htmldjango
autocmd vimOptions BufNewFile,BufReadPost *.mdx       setfiletype markdown
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
const sessionDir = expand('~/.cache/vim')
const project_name = fnamemodify(getcwd(), ':t')

def SaveSession(): void
  if !isdirectory(sessionDir)
    call mkdir(sessionDir, 'p')
  endif
  const path = sessionDir .. '/' .. project_name .. '.session'
  silent execute 'mksession! ' .. fnameescape(path)
enddef

autocmd VimLeavePre * call SaveSession()

def LoadSession(): void
  const path = sessionDir .. '/' .. project_name .. '.session'
  execute 'source' fnameescape(path)
enddef

nnoremap <leader>s :call <sid>LoadSession()<CR>

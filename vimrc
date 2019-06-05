"
"
"

set nocompatible

if has("autocmd")
  " remove existing autocmds
  autocmd!
endif

try
  " start pathogen
  execute pathogen#infect()
catch
endtry

if has("eval")
  " set the leader to comma
  let mapleader=","

  " NERDTree: Show hidden files
  let NERDTreeShowHidden=1
  let NERDTreeShowBookmarks=1
  let NERDTreeIgnore=['\.pyc$', '\~$']
endif

" editing, tabs, indentation
set shiftwidth=4 softtabstop=4 tabstop=4 expandtab
set background=dark
set autoindent
set smartindent
set shiftround
set nojoinspaces
set nrformats-=octal

" horizontal ellipsis:
if has("digraphs")
  digraphs ,. 8230
endif

" switching between normal and paste while in insert mode
set pastetoggle=<F2>

" window display, mouse, behaviour
if has("mouse")
  set mouse=a
endif
set nowrap
set number
if has("statusline")
  set laststatus=2
  set statusline=%f%<\ %m%r%h%w[%Y;%{&ff};%{&fenc}]%=[hex:\%02.6B]\ [pos:\ %l,%v\ %p%%/%L]
endif
if has("virtualedit")
  set virtualedit=all
endif
set list
if version < 702
  set listchars=tab:\|-,trail:.,extends:>,precedes:<
else
  set listchars=tab:\|-,trail:·,extends:»,precedes:«,nbsp:·
endif
if has("linebreak")
  set cpoptions+=n
  let &showbreak = '   └'
endif
if has("diff")
  set diffopt+=vertical
endif
set autoread
if has("wildmenu")
  set wildmenu
  set wildmode=longest,list:full
endif
set hlsearch incsearch cursorline
if has("wildignore")
  set wildignore=.svn,*.swp,*.pyc,*~
endif
set scrolloff=3
if has("syntax") && version >= 703
  set colorcolumn=79
endif

" vim behaviour, backspace and del fixes, tty and key remappings
set vb t_vb=
set t_kD=[3~
set <C-Left>=[1;5D
set <C-Right>=[1;5C
set backspace=indent,eol,start
set history=1000
set undolevels=1000
if version >= 703
  set undodir=~/tmp/vimtmp,/var/tmp,/tmp
  set undofile
endif
set directory=~/tmp/vimtmp,/var/tmp,/tmp      " don't store swp files together with the originals
set nottimeout    " don't timeout for mappings
if executable("ack")
  set grepprg=ack
endif
set iskeyword-=/:

" files, formats, encodings
set encoding=utf-8
set nobomb
set fileformat=unix
set fileencoding=utf-8
set nobackup
if has("autocmd")
  filetype on
  filetype indent on
  filetype plugin on
endif

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

" Force using hjkl
nnoremap <up>    <nop>
nnoremap <left>  <nop>
nnoremap <right> <nop>
nnoremap <down>  <nop>

" let j and k go through virtual lines
nnoremap j gj
nnoremap k gk

" work around that silly inconsistency
nnoremap Y y$

" Easy window navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" 'magic' to have lines in insert and blocks in normal mode
if has("cursorshape")
  if &term =~ "xterm"
    " let &t_ti.="\e[1 q"
    let &t_SI.="\e[5 q"
    let &t_EI.="\e[1 q"
    " let &t_te.="\e[0 q"
  endif
endif

if has("autocmd")
  " cd to the directory the current file is in
  autocmd BufEnter * execute ":silent! lcd " . expand("%:p:h")

  " auto-completion enabled for some languages
  if has("python")
    autocmd FileType python set omnifunc=pythoncomplete#Complete
  endif
  " smartindent makes trouble when typing comments in Python
  autocmd FileType python set keywordprg=pydoc nosmartindent
  autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS keywordprg=mdn_doc
  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType css,scss set omnifunc=csscomplete#CompleteCSS keywordprg=mdn_doc
  autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
  autocmd FileType php set omnifunc=phpcomplete#CompletePHP keywordprg=php_doc
  autocmd FileType php setlocal iskeyword-=$ comments=s1:/*,mb:*,ex:*/,://,:#
  autocmd BufNewFile,BufRead *.php setlocal iskeyword-=$ comments=s1:/*,mb:*,ex:*/,://,:#

  " set tab width to 2 for HTML, CSS and JS files
  autocmd FileType {mako,vim,html,xhtml,xml,xslt,dtd,svg,css,scss,javascript,json,htmldjango,smarty,mustache,yaml} setlocal shiftwidth=2 softtabstop=2 tabstop=2
  "autocmd FileType {html,xhtml,xml,xslt,dtd,svg,htmldjango,smarty,mako} setlocal nocindent nosmartindent indentexpr=

  " set tabs for Makefiles
  autocmd FileType {gitconfig,make} setlocal shiftwidth=4 softtabstop=4 tabstop=4 noexpandtab

  " set compilers
  autocmd FileType javascript compiler jshint

  " correct filetype detection
  autocmd BufNewFile,BufRead *.mako set ft=mako
  autocmd BufNewFile,BufRead *.json set ft=json
  autocmd BufNewFile,BufRead *.svg  set ft=svg
  autocmd BufNewFile,BufRead *.rdf  set ft=xml
  autocmd BufNewFile,BufRead *.mustache  set ft=mustache

  " In XML, let the hyphen be a keyword boundary, too
  autocmd FileType {xml,xslt,html,xhtml,dtd} setlocal iskeyword+=-

  " remove the : from keywords in CSS and Sass
  autocmd FileType {css,sass,scss} setlocal iskeyword-=:

  " Disable code folding for HTML and friends. This lead to errors, when
  " folding kicked in after altering an attribute
  autocmd FileType {xml,xslt,html,xhtml,dtd,svg} setlocal foldmethod=manual

  " listing disabled for some formats
  autocmd FileType {taglist,help} setlocal nolist

  " ctags for python
  autocmd FileType python set tags+=$HOME/.vim/tags/python26.ctags

  " map *.md to Markdown
  autocmd! filetypedetect BufNewFile,BufRead *.md set filetype=markdown

  " map *.journal to Ledger
  autocmd BufEnter *.journal setlocal filetype=ledger

  " autostart NERDTree
  if &columns > 140
    " autocmd VimEnter * if exists(":NERDTree") | :NERDTree | :wincmd p | :endif
    " autocmd BufEnter * if exists(":NERDTree") | :NERDTreeMirror | :en
  endif
  "endif
endif

if has("syntax")
  " Syntax highlighting
  syntax on
  try
    colorscheme molokai
  catch
    colorscheme pablo
  endtry
  highlight CursorLine cterm=NONE ctermbg=black
  highlight ColorColumn ctermbg=235
  autocmd Syntax * highlight ColorColumn ctermbg=235
  highlight Search ctermfg=black ctermbg=250
  highlight htmlItalic ctermfg=236 ctermbg=white
endif

" <http://askubuntu.com/a/392811>: Indent all HTML tags
let g:html_indent_inctags = "html,body,head,tbody"

" end insert mode with <C-CR>
inoremap <C-CR> <Esc><Right>
inoremap <S-CR> <Esc><Right>
" insert <CR> in normal mode via \<CR>
noremap <Leader><Enter> i<CR><Esc>

" toggle the taglist with <F8>
noremap <silent> <F8> :TlistToggle<CR>
inoremap <silent> <F8> <Esc>:TlistToggle<CR>a
let Tlist_Enable_Fold_Column = 0

" toggle the NERDTree with <F9>
noremap <silent> <F9> :NERDTreeToggle %:p:h<CR>

inoremap <lt>PHPCLASS  <lt>?php if(!defined('BASEPATH'))<Space>exit('No<Space>direct<Space>access!');<CR><CR>/**<CR><Space>*<CR><Space>*/<CR>class<Space>Hello<Space>{<CR><CR><Space><Space><Space><Space>public<Space>function<Space>__construct()<Space>{<CR><Space><Space><Space><Space>}<CR><CR>}<CR><CR>//__END__

inoremap :shrug: ¯\_(ツ)_/¯

inoremap nshtml xmlns="http://www.w3.org/1999/xhtml"
inoremap nsxlink xmlns="http://www.w3.org/1999/xlink"
inoremap nssvg xmlns="http://www.w3.org/2000/svg"

" Map for tab commands
nnoremap <C-t> :tabnew<CR>

" Let <leader><space> clear highlighting
nnoremap <leader><space> :noh<CR>
noremap <leader>h :exe "normal " . winwidth(0)/2. "h"<CR>
noremap <leader>l :exe "normal " . winwidth(0)/2. "l"<CR>

" un-camelcase below cursor: A -> _a
noremap <Leader>c i_<Esc>lgul

if has("eval")
  " Abbreviation: Current time
  iab <expr> NOW! strftime("%FT%T%z")
endif


function! OpenInTabs(...)
  let i = 0
  for f in a:000
    if filereadable(f)
      execute "tabedit " . f
    else
      let l = split(expand(f), "\n")
      for ff in l
        if filereadable(ff)
          execute "tabedit " . ff
        endif
      endfor
    endif
  endfor
endfunction
command! -nargs=+ -complete=file OpenInTabs call OpenInTabs(<q-args>)


" HTML quoting and unquoting
function! HtmlEscape()
  silent s/&/\&amp;/eg
  silent s/</\&lt;/eg
  silent s/>/\&gt;/eg
  silent s/"/\&quot;/eg
  " silent s/'/\&apos;/eg
endfunction

function! HtmlUnEscape()
  silent s/&lt;/</eg
  silent s/&gt;/>/eg
  silent s/&quot;/"/eg
  silent s/&apos;/'/eg
  silent s/&amp;/\&/eg
endfunction

nnoremap <silent> <leader>q :call HtmlEscape()<CR>
nnoremap <silent> <leader>u :call HtmlUnEscape()<CR>
vnoremap <silent> <leader>q :call HtmlEscape()<CR>
vnoremap <silent> <leader>u :call HtmlUnEscape()<CR>


" inserting templates
function! Tpl(...)
  if a:0 == "1" && filereadable(expand("$HOME/.vim/templates/" . a:1))
    execute "read $HOME/.vim/templates/" . a:1
  else
    !ls "$HOME/.vim/templates/"
  endif
endfunction
command! -nargs=? Tpl call Tpl(<q-args>)


let php_folding = 1
" let javaScript_fold = 1

" command! -range=% Tidy !tidy -q -asxml -utf8 -w 200 -i 2>/dev/null

" configure the ledger ftplugin
let g:ledger_maxwidth = 76

" skip taglist plugin, if not available
if !executable('ctags') && !executable('ctags')
  let loaded_taglist = 'no'
endif

if filereadable(expand('~/.vim/localrc'))
  exe 'source' '~/.vim/localrc'
endif

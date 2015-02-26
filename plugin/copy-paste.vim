" copy-paste.vim - Enhanced copy and paste
" Author: Manuel Strehl
" Version: 1.0
"
" Enable Windows clipboard using Cygwin getclip / putclip,
" X11 clipboard with xclip and OS X clipboard with pb* consistently
" with the mapping <leader>y and <leader>p
" Based loosely on Vim tips #1623 and #1511.
"
" Licensed under Vim's terms.

if (exists("g:loaded_copy_paste") && g:loaded_copy_paste)
  finish
endif
let g:loaded_copy_paste = 1

" Copy the range to the clipboard {{{1
function! ClipCopy(type, ...) range
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@
  if a:type == "n"
    silent exe a:firstline . "," . a:lastline . "y"
  elseif a:type == "c"
    silent exe a:1 . "," . a:2 . "y"
  else
    silent exe "normal! `<" . a:type . "`>y"
  endif
  if executable("putclip")
    call system("putclip", @@)
  elseif executable("xclip")
    call system("xclip -i -selection c", @@)
  elseif executable("pbcopy")
    let @@ = system("pbcopy", @@)
  endif
  let &selection = sel_save
  let @@ = reg_save
endfunction
" }}}1

" Paste from the clipboard to the range {{{1
function! ClipPaste(type)
  let reg_save = @@
  if executable("getclip")
    " -u converts to UNIX line endings
    let @@ = system("getclip -u")
  elseif executable("xclip")
    " -selection c selects the X CLIPBOARD
    let @@ = system("xclip -o -selection c")
  elseif executable("pbpaste")
    let @@ = system("pbpaste")
  endif
  setlocal paste
  exe "normal " . a:type
  setlocal nopaste
  let @@ = reg_save
endfunction
" }}}1

" Mappings {{{1
vnoremap <silent> <Plug>CnPCopyVisual :call ClipCopy(visualmode(), 1)<CR>
nnoremap <silent> <Plug>CnPCopyNormal :call ClipCopy("n", 1)<CR>
nnoremap <silent> <Plug>CnPCopyLine :call ClipCopy("c", ".", ".")<CR>

nnoremap <silent> <Plug>CnPPastep :call ClipPaste("p")<CR>
nnoremap <silent> <Plug>CnPPasteP :call ClipPaste("P")<CR>

if !exists("g:copy_paste_no_mappings") || ! g:copy_paste_no_mappings
  vmap <leader>y <Plug>CnPCopyVisual
  nmap <leader>y <Plug>CnPCopyNormal
  nmap <leader>Y <Plug>CnPCopyLine

  nmap <leader>p <Plug>CnPPastep
  nmap <leader>P <Plug>CnPPasteP
endif
" }}}1


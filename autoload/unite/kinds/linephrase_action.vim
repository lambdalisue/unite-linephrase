"******************************************************************************
"
" Author:   Alisue <lambdalisue@hashnote.net>
" URL:      http://hashnote.net/
" License:  MIT license
" (C) 2014, Alisue, hashnote.net
"******************************************************************************
let s:save_cpo = &cpo
set cpo&vim


let s:kind = {
      \ 'name': 'linephrase_action',
      \ 'parents': ['openable', 'command'],
      \ 'default_action': 'execute',
      \ 'alias_table': {
      \   'open': 'execute',
      \ },
      \}

function! unite#kinds#linephrase_action#define() " {{{
  return s:kind
endfunction " }}}
call unite#define_kind(s:kind)

let &cpo = s:save_cpo
unlet s:save_cpo
"vim: sts=2 sw=2 smarttab et ai textwidth=0 fdm=marker

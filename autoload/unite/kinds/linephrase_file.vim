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
      \ 'name': 'linephrase_file',
      \ 'parents': ['file'],
      \ 'default_action': 'select',
      \ 'action_table': {
      \   'select': {
      \     'description': 'select linephrases in the linephrase file',
      \     'is_selectable': 1,
      \     'is_start': 1,
      \   },
      \ },
      \ 'alias_table': {
      \   'delete': 'vimfiler__delete',
      \ },
      \}
function! s:kind.action_table.select.func(candidates) " {{{
  let args = map(copy(a:candidates), 'v:val.action__name')
  call insert(args, 'linephrase', 0)
  call unite#start_script([args])
endfunction " }}}

function! unite#kinds#linephrase_file#define() " {{{
  return s:kind
endfunction " }}}
call unite#define_kind(s:kind)


let &cpo = s:save_cpo
unlet s:save_cpo
"vim: sts=2 sw=2 smarttab et ai textwidth=0 fdm=marker

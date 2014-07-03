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
      \ 'name': 'linephrase',
      \ 'parents': ['openable', 'uri'],
      \ 'default_action': 'insert',
      \ 'action_table': {
      \   'open': {
      \     'description': 'open the linephrase file to edit',
      \     'is_selectable': 1,
      \   },
      \   'delete': {
      \     'description': 'delete the linephrase (not file)',
      \     'is_selectable': 1,
      \   },
      \ },
      \}
function! s:kind.action_table.open.func(candidates) " {{{
  for candidate in a:candidates
    if buflisted(unite#util#escape_file_searching(
          \ candidate.action__path))
      execute 'buffer' bufnr(unite#util#escape_file_searching(
          \ candidate.action__path))
    else
      call s:execute_command('edit', candidate)
    endif

    " move cursor to the linenumber
    silent execute candidate.action__linenumber
    silent normal! zz

    call unite#remove_previewed_buffer_list(
          \ bufnr(unite#util#escape_file_searching(
          \       candidate.action__path)))
  endfor
endfunction " }}}
function! s:kind.action_table.delete.func(candidates) " {{{
  redraw
  echohl WarningMsg
  echo 'Delete linephrases'
  echohl None
  echo 'The following linephrases will be removed.'
  for candidate in a:candidates
    echo '-' printf('[%s] %s',
          \ candidate.action__name,
          \ candidate.action__text)
  endfor
  echohl WarningMsg
  echo 'Deleting linephrases cannot be undone.'
  echohl None
  echohl Question
  let yesno = unite#util#input_yesno('Are you sure to remove?')
  echohl None
  if !yesno
    redraw | echohl WarningMsg | echo 'Canceled.' | echohl None
    return
  endif

  for candidate in a:candidates
    let contents = readfile(candidate.action__path)
    call remove(contents, candidate.action__linenumber-1)
    call writefile(contents, candidate.action__path)
  endfor
endfunction " }}}

function! unite#kinds#linephrase#define() " {{{
  return s:kind
endfunction " }}}
call unite#define_kind(s:kind)

let &cpo = s:save_cpo
unlet s:save_cpo
"vim: sts=2 sw=2 smarttab et ai textwidth=0 fdm=marker

"******************************************************************************
" unite-linephrase
"
" A simple unite source which refer a particular file and use each lines of
" the file as candidates
"
" Author:   Alisue <lambdalisue@hashnote.net>
" URL:      http://hashnote.net/
" License:  MIT license
" (C) 2014, Alisue, hashnote.net
"******************************************************************************
let s:save_cpo = &cpo
set cpo&vim


let s:source = {
      \ 'name': 'linephrase',
      \ 'description': 'a line phrase candidates',
      \ 'hooks': {},
      \}
function! s:source.gather_candidates(args, context) abort " {{{
  let linephrases = linephrase#gather_linephrases({'nocache': 1})
  let candidates = []
  for linephrase_name in a:args
    if !has_key(linephrases, linephrase_name)
      echohl WarningMsg
      echo 'No linephrase is found:'
      echohl None
      echo 'A linephrase file name "' . linephrase_name . '" is specified but'
            \ 'not found in "' . g:linephrase#directory . '". Ignored.'
      continue
    endif
    let candidates += linephrases[linephrase_name].candidates
  endfor

  if empty(candidates)
    " filter linephrase files instead
    for linephrase in values(linephrases)
      call add(candidates, {
            \ 'word': linephrase.word,
            \ 'abbr': linephrase.abbr,
            \ 'kind': 'linephrase_file',
            \ 'action__name': linephrase.name,
            \ 'action__description': linephrase.description,
            \ 'action__path': linephrase.path,
            \ 'action__directory': fnamemodify(linephrase.path, ':p:h'),
            \})
    endfor
    call add(candidates, {
          \ 'word': "Create a new linephrase file",
          \ 'abbr': "[[ Create a new linephrase file ]]",
          \ 'kind': 'linephrase_action',
          \ 'action__command': "call linephrase#new()",
          \})
  endif
  return candidates
endfunction " }}}
function! s:source.hooks.on_syntax(args, context) abort " {{{
  execute 'syntax match uniteSource__linephrase_action'
        \ '/\s*\zs\[\[.*\]\]\ze\s*$/'
        \ 'contained containedin=uniteSource__linephrase'
  execute 'syntax match uniteSource__linephrase_description'
        \ '/ : \zs.*\ze\s*$/'
        \ 'contained containedin=uniteSource__linephrase'
  execute 'syntax match uniteSource__linephrase_error'
        \ '/<<< Error: .* >>>/'
        \ 'contained containedin=uniteSource__linephrase'
  execute 'syntax match uniteSource__linephrase_warning'
        \ '/<<< Warning: .* >>>/'
        \ 'contained containedin=uniteSource__linephrase'
  highlight default link uniteSource__linephrase_action       Function
  highlight default link uniteSource__linephrase_description  Special
  highlight default link uniteSource__linephrase_error        ErrorMsg
  highlight default link uniteSource__linephrase_warning      WarningMsg
endfunction " }}}


function! unite#sources#linephrase#define() " {{{
  return s:source
endfunction " }}}
call unite#define_source(s:source)  " for script reload


let &cpo = s:save_cpo
unlet s:save_cpo
"vim: sts=2 sw=2 smarttab et ai textwidth=0 fdm=marker

"******************************************************************************
"
" Author:   Alisue <lambdalisue@hashnote.net>
" URL:      http://hashnote.net/
" License:  MIT license
" (C) 2014, Alisue, hashnote.net
"******************************************************************************
let s:save_cpo = &cpo
set cpo&vim


function! linephrase#load_linephrase(path) abort " {{{
  let name = fnamemodify(a:path, ':t:r')
  let error = ''
  let content = readfile(a:path)
  " separate the content to a description line and candidates
  if len(content) < 1
    let error = 'Error: no description line is found'
    let description = ''
    let candidates = []
  else
    let description = content[0]
    " create candidates
    let candidates = []
    let linenumber = 2
    let previous_candidate = {}
    for line in content[1:]
      " skip empty line or comment line
      if empty(line) || line =~# '^#'
        let linenumber += 1
        continue
      endif
      if line =~# '^!'
        if !empty(previous_candidate)
          let previous_candidate['source__description'] = line[1:]
          let previous_candidate['word'] = printf('%s : %s',
                \ previous_candidate.action__text,
                \ previous_candidate.source__description)
        endif
        let linenumber += 1
        continue
      endif
      let previous_candidate = {
            \ 'word': line,
            \ 'kind': 'linephrase',
            \ 'source__description': '',
            \ 'action__text': line,
            \ 'action__name': name,
            \ 'action__path': a:path,
            \ 'action__linenumber': linenumber,
            \}
      call add(candidates, previous_candidate)
      let linenumber += 1
    endfor
    " if no candidates are found, show the warning message
    if len(candidates) == 0
      let error = 'Warning: no linephrase is found in this file'
    endif
  endif
  let word = printf("%s : %s", name, description)
  if empty(error)
    let abbr = word
  else
    let abbr = printf("%s <<< %s >>> : %s", name, error, description)
  endif
  return {
        \ 'word': word,
        \ 'abbr': abbr,
        \ 'name': name,
        \ 'path': a:path,
        \ 'error': error,
        \ 'description': description,
        \ 'candidates': candidates,
        \}
endfunction " }}}
function! linephrase#gather_linephrases(...) abort " {{{
  let settings = extend({
        \ 'directory': g:linephrase#directory,
        \ 'nocache': 0,
        \}, get(a:000, 0, {}))
  if settings.nocache || !exists(s:cache)
    let filenames = unite#util#glob(
          \ printf('%s/*.linephrase', settings.directory))
    let s:cache = {}
    for filename in filenames
      let linephrase = linephrase#load_linephrase(filename)
      if type(linephrase) == 0
        " invalid linephrase, ignore
        unlet linephrase
        continue
      endif
      let s:cache[linephrase.name] = linephrase
    endfor
  endif
  return s:cache
endfunction " }}}
function! linephrase#new(...) abort " {{{
  let name = get(a:000, 0, '')
  if empty(name)
    echohl Title
    echo 'New linephrase file:'
    echohl None
    echo 'This is used as a filename thus you cannot use several characters.'
    echohl Question
    let name = input('Please input a new linephrase file name: ')
    echohl None
    if empty(name)
      echohl WarningMsg
      echo 'Canceled.'
      echohl None
      return
    endif
  endif

  " create if the target directory is missing
  if !isdirectory(g:linephrase#directory)
    call mkdir(g:linephrase#directory, 'p')
  endif

  execute "new" printf("%s/%s.linephrase", g:linephrase#directory, name)
  let template = [
        \ 'Write a description of this linephrase file here',
        \ '#',
        \ '# This is a linephrase file. All lines except the following will be included as unite candidates.',
        \ '#',
        \ '# - Empty lines',
        \ '# - Comment lines (a line start from #)',
        \ '# - Candidate description lines (a line start from !)',
        \ '#',
        \ '# Candidate description lines are used as a description of the previous candidate (optional).',
        \ '#',
        \ 'This is a sample candidate',
        \ '!This is a sample candidate description (of above)',
        \ '',
        \]
  let i = 0
  for line in template
    let i += 1
    call setline(i, line)
  endfor
  execute len(template) + 1
endfunction " }}}

let s:settings = {
      \ 'directory': printf('"%s"', expand('~/.vim/linephrase')),
      \}
function! s:init() abort " {{{
  for [key, value] in items(s:settings)
    let name = printf('g:linephrase#%s', key)
    if !exists(name)
      execute "let" name "=" value
    endif
  endfor
endfunction " }}}
call s:init()


let &cpo = s:save_cpo
unlet s:save_cpo
"vim: sts=2 sw=2 smarttab et ai textwidth=0 fdm=marker

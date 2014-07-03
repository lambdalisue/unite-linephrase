"******************************************************************************
"
" Author:   Alisue <lambdalisue@hashnote.net>
" URL:      http://hashnote.net/
" License:  MIT license
" (C) 2014, Alisue, hashnote.net
"******************************************************************************
if exists('b:current_syntax')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

syntax clear
syntax match Comment /^#.*$/
syntax match Special /^!.*$/
syntax match Title   /\%1l.*/

let b:current_syntax = 'linephrase'
let &cpo = s:save_cpo
unlet s:save_cpo
"vim: sts=2 sw=2 smarttab et ai textwidth=0 fdm=marker

" Vim indent file
" Language   : VisualBasic.NET
" Maintainers: OGURA Daiki
" Last Change: 2013-01-25

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal autoindent
setlocal nosmartindent
setlocal expandtab
setlocal tabstop<
setlocal softtabstop=4
setlocal shiftwidth=4

setlocal indentexpr=VbNetGetIndent(v:lnum)
setlocal indentkeys=!^F,o,O,0#,0=~catch,0=~finally,0=~else,0=~elseif,0=~end,0=~wend,0=~next,=~select,0=~case,0=~loop,<:>

" Only define the function once.
if exists("*VbNetGetIndent")
  finish
endif
let s:keepcpo= &cpo
set cpo&vim

let s:LABELS_OR_PREPROC = '^\s*\(\<\k\+\>:\s*$\|#.*\)'
let s:LINE_CONTINUATION = '\(\s_\|,\|(\|{\|&\|=\|+\|-\|\*\|/\|\<mod\>\|<\|>\|\^\|\<and\>\|\<andalso\>\|\<or\>\|\<orelse\>\|\<like\>\|\<xor\>\|\<is\>\|\<isnot\>\|\.\|\<in\>\|\<from\>\)$'
let s:LINE_CONTINUATION_AFTER = '^\s*\(}\|)\)'

function! VbNetGetIndent(lnum)
  let ACCESS_MODIFIER = '\<\%(Public\|Protected\|Private\|Friend\)\>'

  " labels and preprocessor get zero indent immediately
  let this_line = s:getline(a:lnum)
  if this_line =~? s:LABELS_OR_PREPROC
    return 0
  endif

  " Find a non-blank line above the current line.
  " Skip over labels and preprocessor directives.
  let prev_lnum = s:my_prevnonblank(a:lnum - 1)
  let previous_line = s:getline(prev_lnum)

  " Hit the start of the file, use zero indent.
  if prev_lnum == 0
    return 0
  endif

  " when previous-line is a part of statements split by the line-continuation character,
  " get a start line of the previous statement.
  let prev_statement_start_lnum = s:getPrevStatementLinenr(prev_lnum)
  let previous_statement = s:getline(prev_statement_start_lnum)
  let ind = indent(prev_statement_start_lnum)

  "echomsg "previous:".prev_lnum.",prev_statement:".prev_statement_start_lnum.",base_indent:".ind

  " this block is for the statement split by the line-continuation character.
  if (col('.') - 1) == matchend(this_line, '^\s*')
    " Indent by a new line
    if previous_line =~? '\s_$'
      return -1
    elseif previous_line =~? s:LINE_CONTINUATION
      if prev_lnum == prev_statement_start_lnum
        return ind + &l:shiftwidth
      else
        return -1
      endif
    endif
  else
    if previous_line =~? s:LINE_CONTINUATION || this_line =~? s:LINE_CONTINUATION_AFTER
      return -1
    endif
  endif

  " Add indent
  if previous_statement =~? '^\s*\('.ACCESS_MODIFIER.'\s\+\)\?\<\%(Namespace\|Class\|Module\|Enum\|Interface\|Operator\)\>'
    let ind += &l:shiftwidth
  elseif previous_statement =~? '\(\<End\>\s*\)\@<!\<\%(Function\|Sub\|Property\)\>'
    let ind += &l:shiftwidth
  elseif previous_statement =~? '\<\(Overrides\|Overridable\|Overloads\|NotOverridable\|MustOverride\|Shadows\|Shared\|ReadOnly\|WriteOnly\)\>'
    let ind += &l:shiftwidth
  elseif previous_line =~? '\<Then\>'
    let ind += &l:shiftwidth
  elseif previous_statement =~? '^\s*\<\(Select Case\|Case\|Else\|ElseIf\|For\|While\|With\|Using\|Try\|Catch\|Finally\)\>'
    let ind += &l:shiftwidth
  endif

  " Subtract indent
  if this_line =~? '^\s*\<End\>\s\+\<Select\>'
    if previous_statement !~? '^\s*\<Select\>'
      let ind -= &l:shiftwidth * 2
    else
      " this case is for an empty 'select' -- 'end select'
      let ind -= &l:shiftwidth
    endif
  elseif this_line =~? '^\s*\<\(Case\|Default\)\>'
    if previous_statement !~? '^\s*\<Select\>'
      let ind -= &l:shiftwidth
    endif
  elseif this_line =~? '^\s*\<\(End\|Else\|ElseIf\|Until\|Loop\|Next\|Wend\|Catch\|Finally\)\>'
    let ind -= &l:shiftwidth
  endif

  return ind
endfunction

" Get a string of line {lnum} without comment
function! s:getline(lnum)
  let line = getline(a:lnum)
  return substitute(line, '\s*''.*$', '', '')
endfunction

" Find a non-blank line above the current line.
" Skip over labels, preprocessor directives and comment line.
function! s:my_prevnonblank(lnum)
  let linenum = prevnonblank(a:lnum)
  while getline(linenum) =~? s:LABELS_OR_PREPROC || getline(linenum) =~? '^\s*'''
    let linenum = prevnonblank(linenum - 1)
  endwhile
  return linenum < 0 ? 0 : linenum
endfunction

" get a start line of the previous statement.
" e.g.  Dim foo() As String = {       ' <- return a number of this line
"                               "foo",
"                               "bar"
"                             }
function! s:getPrevStatementLinenr(lnum)
  let linenum = s:my_prevnonblank(a:lnum)
  let prev_statement_line = linenum
  while linenum > 0 && getline(linenum) =~? s:LINE_CONTINUATION_AFTER
    let prev_statement_line = linenum
    let linenum = s:my_prevnonblank(linenum - 1)
  endwhile
  if linenum > 0 && getline(linenum) !~? s:LINE_CONTINUATION
    let prev_statement_line = linenum
    let linenum = s:my_prevnonblank(linenum - 1)
  endif
  while linenum > 0 && getline(linenum) =~? s:LINE_CONTINUATION
    let prev_statement_line = linenum
    let linenum = s:my_prevnonblank(linenum - 1)
  endwhile
  return prev_statement_line
endfunction

let &cpo = s:keepcpo
unlet s:keepcpo

let b:undo_indent = 'setlocal '.join([
\   'autoindent<',
\   'expandtab<',
\   'indentexpr<',
\   'indentkeys<',
\   'shiftwidth<',
\   'softtabstop<',
\ ])

" vim:sw=2

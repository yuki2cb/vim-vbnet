if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

let s:keepcpo = &cpo
set cpo&vim

setlocal cinkeys-=0#
setlocal indentkeys-=0#
setlocal suffixesadd=.vb
setlocal comments-=:%
setlocal commentstring='%s

function! s:VbSearch(pattern, flags)
    let cnt = v:count1
    while cnt > 0
      call search(a:pattern, a:flags)
      let cnt = cnt - 1
    endwhile
endfun

nnoremap <buffer> <silent> [[ :<C-u>call <SID>VbSearch('^[^'']*\%(\<end\> \)\@<!\(function\<Bar>sub\)', 'bW')<cr>
nnoremap <buffer> <silent> ]] :<C-u>call <SID>VbSearch('^[^'']*\%(\<end\> \)\@<!\(function\<Bar>sub\)', 'W')<cr>
nnoremap <buffer> <silent> [] :call <SID>VbSearch('^\s*\<end\>\s\+\(function\\|sub\)', 'bW')<cr>
nnoremap <buffer> <silent> ][ :call <SID>VbSearch('^\s*\<end\>\s\+\(function\\|sub\)', 'W')<cr>

if exists("loaded_matchit")
    let b:match_ignorecase = 1
    let headsp = '\%(^\s*\)\@<='
    let no_end = '\%(\<End\> \)\@<!'
    let b:match_words =
          \   headsp.'\<Namespace\>:'.headsp.'\<End Namespace\>,'
          \ . no_end.'\<Module\>:'.headsp.'\<End Module\>,'
          \ . no_end.'\<Class\>:'.headsp.'\<End Class\>,'
          \ . no_end.'\<Interface\>:'.headsp.'\<End Interface\>,'
          \ . no_end.'\<Property\>:'.headsp.'\<End Property\>,'
          \ . no_end.'\<Enum\>:'.headsp.'\<End Enum\>,'
          \ . no_end.'\<Function\>:'.headsp.'\<End Function\>,'
          \ . no_end.'\<Sub\>:'.headsp.'\<End Sub\>,'
          \ . headsp.'\<Get\>:'.headsp.'\<End Get\>,'
          \ . headsp.'\<Set\>:'.headsp.'\<End Set\>,'
          \ . headsp.'\<For\>:'.headsp.'\<Next\>,'
          \ . headsp.'\<While\>:'.headsp.'\<End While\>,'
          \ . headsp.'\<Select\>:'.headsp.'\<Case\>:'.headsp.'\<End Select\>,'
          \ . headsp.'\<Using\>:'.headsp.'\<End Using\>,'
          \ . headsp.'\<With\>:'.headsp.'\<End With\>,'
          \ . headsp.'\<Try\>:'.headsp.'\<Catch\>:'.headsp.'\<Finally\>:'.headsp.'\<End Try\>,'
          \ . headsp.'\<If\>:'.headsp.'\<\%(ElseIf\|Else\)\>:'.headsp.'\<End If\>'
endif

let &cpo = s:keepcpo
unlet s:keepcpo

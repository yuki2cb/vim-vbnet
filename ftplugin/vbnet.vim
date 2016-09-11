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

nnoremap <buffer> <silent> [[ :<C-u>call <SID>VbSearch('^[^'']*\%(\<\(end\<Bar>exit\)\> \)\@<!\<\(function\<Bar>sub\)\>', 'bW')<cr>
nnoremap <buffer> <silent> ]] :<C-u>call <SID>VbSearch('^[^'']*\%(\<\(end\<Bar>exit\)\> \)\@<!\<\(function\<Bar>sub\)\>', 'W')<cr>
nnoremap <buffer> <silent> [] :call <SID>VbSearch('^\s*\<end\>\s\+\(function\\|sub\)', 'bW')<cr>
nnoremap <buffer> <silent> ][ :call <SID>VbSearch('^\s*\<end\>\s\+\(function\\|sub\)', 'W')<cr>

if exists("loaded_matchit")
    let b:match_ignorecase = 1
    let headsp = '\%(^\s*\)\@<='
    let no_end = '\%(\<\(end\|exit\)\> \)\@<!'
    let b:match_words =
          \   headsp.'\<namespace\>:'.headsp.'\<end namespace\>,'
          \ . no_end.'\<module\>:'.headsp.'\<end module\>,'
          \ . no_end.'\<class\>:'.headsp.'\<end class\>,'
          \ . no_end.'\<interface\>:'.headsp.'\<end interface\>,'
          \ . no_end.'\<property\>:'.headsp.'\<end property\>,'
          \ . no_end.'\<enum\>:'.headsp.'\<end enum\>,'
          \ . no_end.'\<function\>:'.headsp.'\<end function\>,'
          \ . no_end.'\<sub\>:'.headsp.'\<end sub\>,'
          \ . headsp.'\<get\>:'.headsp.'\<end get\>,'
          \ . headsp.'\<set\>:'.headsp.'\<end set\>,'
          \ . headsp.'\<for\>:'.headsp.'\<next\>,'
          \ . headsp.'\<while\>:'.headsp.'\<end while\>,'
          \ . headsp.'\<select\>:'.headsp.'\<case\>:'.headsp.'\<end select\>,'
          \ . headsp.'\<using\>:'.headsp.'\<end using\>,'
          \ . headsp.'\<with\>:'.headsp.'\<end with\>,'
          \ . headsp.'\<try\>:'.headsp.'\<catch\>:'.headsp.'\<finally\>:'.headsp.'\<end try\>,'
          \ . headsp.'\<if\>:'.headsp.'\<\%(elseif\|else\)\>:'.headsp.'\<end if\>'
endif

let &cpo = s:keepcpo
unlet s:keepcpo

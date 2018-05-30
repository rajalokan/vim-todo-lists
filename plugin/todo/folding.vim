setlocal foldmethod=expr

set fillchars=fold:\ 

setlocal foldexpr=GetTodoFold(v:lnum)

function! GetTodoFold(lnum)
    if getline(a:lnum) =~? '\v^\s*$'
        return '-1'
    endif

    if getline(a:lnum) =~? '^.*:.*'
        return '1'
    elseif getline(a:lnum) =~? '^.*|.*'
        return '0'
    endif

endfunction

setlocal foldtext=TodoFoldText()

function! TodoFoldText()
    let l:line = getline(v:foldstart)
    let l:n_lines = v:foldend - v:foldstart + 1
    return "        +--- Sub Tasks (" . l:n_lines . ")"
endfunction

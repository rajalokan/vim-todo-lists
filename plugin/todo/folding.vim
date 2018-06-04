setlocal foldmethod=expr

set fillchars=fold:\ 

setlocal foldexpr=GetTodoFold(v:lnum)

function! IsEmptyLine(line)
    if a:line =~? '\v^\s*$'
        return 1
    endif
    return 0
endfunction

function! IsStory(line)
    if len(split(a:line, ':')) == 1
        return 1
    endif
    return 0
endfunction

function! IsTaskHeader(line)
    if a:line =~? '^.*: \(Done\|Later\|Wishlist\).*$'
        return 1
    endif
    return 0
endfunction

function! GetTodoFold(lnum)
    let l:line = getline(a:lnum)
    
    
    if IsEmptyLine(l:line)
        return '-1'
    elseif IsStory(l:line)
        return '0'
    elseif IsTaskHeader(l:line)
        return '>2'
    endif
    return '2'
    
    if getline(a:lnum) =~? '\v^\s*$'
        return '-1'
    endif

    if getline(a:lnum) =~? '^.*:.*' && getline(a:lnum) =~? '^.*\[L\].*'
        return '2'
    elseif getline(a:lnum) =~? '^.*:.*' && getline(a:lnum) =~? '^.*\[X\].*'
        return '2'
    elseif getline(a:lnum) =~? '^.*:[].*'
        return '1'
    elseif getline(a:lnum) =~? '^.*|.*'
        return '0'
    endif

endfunction

setlocal foldtext=TodoFoldText()

function! TodoFoldText()
    let l:line = getline(v:foldstart)
    let l:n_lines = v:foldend - v:foldstart + 1
    if v:foldlevel == 1
        return "        +--- Sub Tasks (" . l:n_lines . ")"
    elseif v:foldlevel == 2
        return "        +--- Later Tasks (" . l:n_lines . ")"
    endif
    
endfunction

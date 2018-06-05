setlocal foldmethod=expr

set fillchars=fold:\ 

setlocal foldexpr=GetTodoFold(v:lnum)

function! IsEmptyLine(line)
    if a:line =~? '\v^\s*$'
        return 1
    endif
    return 0
endfunction

function! GetTodoType(line)
    if IsEmptyLine(a:line)
        return 'Blank'
    endif
        
    if strpart(a:line, 2, 3) =~? '^\[.\]$'
        return 'Story'
    elseif strpart(a:line, 6, 3) =~? '^\[.\]$'
        return 'Task'
    endif
endfunction


function! GetState(line)
    if IsEmptyLine(a:line)
        return -1
    endif
    if strpart(a:line, 2, 3) =~? '^\[.\]$'
        return -1
    endif
    return strpart(a:line, 7, 1)
endfunction


function! InSpecialState(line)
    if GetState(a:line) == 'W' || GetState(a:line) == 'X' || GetState(a:line) == 'L'
        return 1
    endif 
    return 0
endfunction


function! GetTodoFold(lnum)
    let l:line = getline(a:lnum)
    let l:prevline = getline(a:lnum-1)
    let l:type = GetTodoType(l:line)
    let l:state = GetState(l:line)
    let l:prevline_state = GetState(l:prevline)
    
    if IsEmptyLine(l:line)
        return '-1'
    elseif l:type == 'Story'
        return '0'
    endif
    
    if !InSpecialState(l:line)
        return '1'
    elseif l:state == l:prevline_state
        return '2'
    else 
        return '>2'
    
endfunction

setlocal foldtext=TodoFoldText()

function! TodoFoldText()
    let l:line = getline(v:foldstart)
    let l:n_lines = v:foldend - v:foldstart + 1
    
    if v:foldlevel == 1
        return "      [+] Tasks (" . l:n_lines . ")"
    elseif v:foldlevel == 2 && GetState(l:line) == 'W'
        return "      [+] Wishlists (" . l:n_lines . ")"
    elseif v:foldlevel == 2 && GetState(l:line) == 'L'
        return "      [+] Later (" . l:n_lines . ")"
    elseif v:foldlevel == 2 && GetState(l:line) == 'X'
        return "      [+] Done (" . l:n_lines . ")"
    endif
    
endfunction

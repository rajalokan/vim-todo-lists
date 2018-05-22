" MIT License
"
" Copyright (c) 2017 Alexander Serebryakov (alex.serebr@gmail.com)
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to
" deal in the Software without restriction, including without limitation the
" rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
" sell copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
" FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
" IN THE SOFTWARE.


" Initializes plugin settings and mappings
function! VimTodoListsInit()
  set filetype=todo
  set foldlevel=99
  setlocal tabstop=2
  setlocal shiftwidth=2 expandtab
  setlocal cursorline
  setlocal noautoindent
  colorscheme todo

  nmap <leader>t-1 :vs yesterday.todo<cr>
  nmap <leader>t1 :vs tomorrow.todo<cr>
  nmap <leader>later :vs later.todo<cr>
  nmap <leader>wish :vs wishlist.todo<cr>

  if exists('g:VimTodoListsCustomKeyMapper')
    try
      call call(g:VimTodoListsCustomKeyMapper, [])
    catch
      echo 'VimTodoLists: Error in custom key mapper.'
           \.' Falling back to default mappings'
      call VimTodoListsSetItemMode()
    endtry
  else
    call VimTodoListsSetItemMode()
  endif

endfunction


" Sets the item done
function! VimTodoListsSetItemDone(lineno)
  let l:line = getline(a:lineno)
  call setline(a:lineno, substitute(l:line, '^\(\s*\)\[ \]', '\1[X]', ''))
endfunction

" Sets the item later
function! VimTodoListsSetItemLater(lineno)
  let l:line = getline(a:lineno)
  call setline(a:lineno, substitute(l:line, '^\(\s*\)\[ \]', '\1[L]', ''))
endfunction

" Sets the item wishlist
function! VimTodoListsSetItemWishlist(lineno)
  let l:line = getline(a:lineno)
  call setline(a:lineno, substitute(l:line, '^\(\s*\)\[ \]', '\1[W]', ''))
endfunction

" Sets the item notes
function! VimTodoListsSetItemNotes(lineno)
  let l:line = getline(a:lineno)
  call setline(a:lineno, substitute(l:line, '^\(\s*\)\[ \]', '\1[N]', ''))
endfunction

" Sets the item Question
function! VimTodoListsSetItemQuestion(lineno)
  let l:line = getline(a:lineno)
  call setline(a:lineno, substitute(l:line, '^\(\s*\)\[ \]', '\1[?]', ''))
endfunction

" Sets the item Tomorrow
function! VimTodoListsSetItemTomorrow(lineno)
  let l:line = getline(a:lineno)
  call setline(a:lineno, substitute(l:line, '^\(\s*\)\[ \]', '\1[>]', ''))
endfunction

" Sets the item not done
function! VimTodoListsSetItemNotDone(lineno)
  let l:line = getline(a:lineno)
  call setline(a:lineno, substitute(l:line, '^\(\s*\)\[X\]', '\1[ ]', ''))
endfunction

" Sets the item not later
function! VimTodoListsSetItemNotLater(lineno)
  let l:line = getline(a:lineno)
  call setline(a:lineno, substitute(l:line, '^\(\s*\)\[L\]', '\1[ ]', ''))
endfunction

" Sets the item not wishlist
function! VimTodoListsSetItemNotWishlist(lineno)
  let l:line = getline(a:lineno)
  call setline(a:lineno, substitute(l:line, '^\(\s*\)\[W\]', '\1[ ]', ''))
endfunction

" Sets the item not notes
function! VimTodoListsSetItemNotNotes(lineno)
  let l:line = getline(a:lineno)
  call setline(a:lineno, substitute(l:line, '^\(\s*\)\[N\]', '\1[ ]', ''))
endfunction

" Sets the item not question
function! VimTodoListsSetItemNotQuestion(lineno)
  let l:line = getline(a:lineno)
  call setline(a:lineno, substitute(l:line, '^\(\s*\)\[?\]', '\1[ ]', ''))
endfunction

" Sets the item not tomorrow
function! VimTodoListsSetItemNotTomorrow(lineno)
  let l:line = getline(a:lineno)
  call setline(a:lineno, substitute(l:line, '^\(\s*\)\[>\]', '\1[ ]', ''))
endfunction

" Checks that line is a todo list item
function! VimTodoListsLineIsItem(line)
  if match(a:line, '^\s*\[[ X]\].*') != -1
    return 1
  endif

  return 0
endfunction

" Checks that item is not done
function! VimTodoListsItemIsNotMarked(line)
  if match(a:line, '^\s*\[ \].*') != -1
    return 1
  endif

  return 0
endfunction

" Checks that item is done
function! VimTodoListsItemIsDone(line)
  if match(a:line, '^\s*\[X\].*') != -1
    return 1
  endif

  return 0
endfunction

" Checks that item is later
function! VimTodoListsItemIsLater(line)
  if match(a:line, '^\s*\[L\].*') != -1
    return 1
  endif

  return 0
endfunction

" Checks that item is wishlist
function! VimTodoListsItemIsWishlist(line)
  if match(a:line, '^\s*\[W\].*') != -1
    return 1
  endif

  return 0
endfunction

" Checks that item is notes
function! VimTodoListsItemIsNotes(line)
  if match(a:line, '^\s*\[N\].*') != -1
    return 1
  endif

  return 0
endfunction

" Checks that item is question
function! VimTodoListsItemIsQuestion(line)
  if match(a:line, '^\s*\[?\].*') != -1
    return 1
  endif

  return 0
endfunction

" Checks that item is question
function! VimTodoListsItemIsTomorrow(line)
  if match(a:line, '^\s*\[>\].*') != -1
    return 1
  endif

  return 0
endfunction

" Returns the line number of the brother item in specified range
function! VimTodoListsBrotherItemInRange(line, range)
  let l:indent = VimTodoListsCountLeadingSpaces(getline(a:line))
  let l:result = -1

  for current_line in a:range
    if VimTodoListsLineIsItem(getline(current_line)) == 0
      break
    endif

    if (VimTodoListsCountLeadingSpaces(getline(current_line)) == l:indent)
      let l:result = current_line
      break
    elseif (VimTodoListsCountLeadingSpaces(getline(current_line)) > l:indent)
      continue
    else
      break
    endif
  endfor

  return l:result
endfunction


" Finds the insert position above the item
function! VimTodoListsFindTargetPositionUp(lineno)
  let l:range = range(a:lineno, 1, -1)
  let l:candidate_line = VimTodoListsBrotherItemInRange(a:lineno, l:range)
  let l:target_line = -1

  while l:candidate_line != -1
    let l:target_line = l:candidate_line
    let l:candidate_line = VimTodoListsBrotherItemInRange(
      \ l:candidate_line, range(l:candidate_line - 1, 1, -1))

    if l:candidate_line != -1 &&
      \ VimTodoListsItemIsNotDone(getline(l:candidate_line)) == 1
      let l:target_line = l:candidate_line
      break
    endif
  endwhile

  return VimTodoListsFindLastChild(l:target_line)
endfunction


" Finds the insert position below the item
function! VimTodoListsFindTargetPositionDown(line)
  let l:range = range(a:line, line('$'))
  let l:candidate_line = VimTodoListsBrotherItemInRange(a:line, l:range)
  let l:target_line = -1

  while l:candidate_line != -1
    let l:target_line = l:candidate_line
    let l:candidate_line = VimTodoListsBrotherItemInRange(
      \ l:candidate_line, range(l:candidate_line + 1, line('$')))
  endwhile

  return VimTodoListsFindLastChild(l:target_line)
endfunction


" Moves the item subtree to the specified position
function! VimTodoListsMoveSubtree(lineno, position)
  if exists('g:VimTodoListsMoveItems')
    if g:VimTodoListsMoveItems != 1
      return
    endif
  endif

  let l:subtree_length = VimTodoListsFindLastChild(a:lineno) - a:lineno + 1

  let l:cursor_pos = getcurpos()
  call cursor(a:lineno, l:cursor_pos[4])

  " Update cursor position
  let l:cursor_pos[1] = a:lineno

  " Copy subtree to the required position
  execute 'normal! ' . l:subtree_length . 'Y'
  call cursor(a:position, l:cursor_pos[4])

  if a:lineno < a:position
    execute 'normal! p'
    " In case of moving item down cursor should be returned to exact position
    " where it was before
    call cursor(l:cursor_pos[1], l:cursor_pos[4])
  else
    let l:indent = VimTodoListsCountLeadingSpaces(getline(a:lineno))

    if VimTodoListsItemIsDone(getline(a:position)) &&
       \ (VimTodoListsCountLeadingSpaces(getline(a:position)) == l:indent)
      execute 'normal! P'
    else
      execute 'normal! p'
    endif

    " In case of moving item up the text became one longer by a subtree length
    call cursor(l:cursor_pos[1] + l:subtree_length, l:cursor_pos[4])
  endif

  " Delete subtree in the initial position
  execute 'normal! ' . l:subtree_length . 'dd'

endfunction


" Moves the subtree up
function! VimTodoListsMoveSubtreeUp(lineno)
  let l:move_position = VimTodoListsFindTargetPositionUp(a:lineno)

  if l:move_position != -1
    call VimTodoListsMoveSubtree(a:lineno, l:move_position)
  endif
endfunction


" Moves the subtree down
function! VimTodoListsMoveSubtreeDown(lineno)
  let l:move_position = VimTodoListsFindTargetPositionDown(a:lineno)

  if l:move_position != -1
    call VimTodoListsMoveSubtree(a:lineno, l:move_position)
  endif
endfunction


" Counts the number of leading spaces
function! VimTodoListsCountLeadingSpaces(line)
  return (strlen(a:line) - strlen(substitute(a:line, '^\s*', '', '')))
endfunction


" Returns the line number of the parent
function! VimTodoListsFindParent(lineno)
  let l:indent = VimTodoListsCountLeadingSpaces(getline(a:lineno))
  let l:parent_lineno = -1

  for current_line in range(a:lineno, 1, -1)
    if (VimTodoListsLineIsItem(getline(current_line)) &&
      \ VimTodoListsCountLeadingSpaces(getline(current_line)) < l:indent)
      let l:parent_lineno = current_line
      break
    endif
  endfor

  return l:parent_lineno
endfunction


" Returns the line number of the last child
function! VimTodoListsFindLastChild(lineno)
  let l:indent = VimTodoListsCountLeadingSpaces(getline(a:lineno))
  let l:last_child_lineno = a:lineno

  " If item is the last line in the buffer it has no children
  if a:lineno == line('$')
    return l:last_child_lineno
  endif

  for current_line in range (a:lineno + 1, line('$'))
    if (VimTodoListsLineIsItem(getline(current_line)) &&
      \ VimTodoListsCountLeadingSpaces(getline(current_line)) > l:indent)
      let l:last_child_lineno = current_line
    else
      break
    endif
  endfor

  return l:last_child_lineno
endfunction


" " Marks the parent done if all children are done
" function! VimTodoListsUpdateParent(lineno)
"   let l:parent_lineno = VimTodoListsFindParent(a:lineno)
"
"   " No parent item
"   if l:parent_lineno == -1
"     return
"   endif
"
"   let l:last_child_lineno = VimTodoListsFindLastChild(l:parent_lineno)
"
"   " There is no children
"   if l:last_child_lineno == l:parent_lineno
"     return
"   endif
"
"   for current_line in range(l:parent_lineno + 1, l:last_child_lineno)
"     if VimTodoListsItemIsNotDone(getline(current_line)) == 1
"       " Not all children are done
"       call VimTodoListsSetItemNotDone(l:parent_lineno)
"       call VimTodoListsMoveSubtreeUp(l:parent_lineno)
"       call VimTodoListsUpdateParent(l:parent_lineno)
"       return
"     endif
"   endfor
"
"   call VimTodoListsSetItemDone(l:parent_lineno)
"   call VimTodoListsMoveSubtreeDown(l:parent_lineno)
"   call VimTodoListsUpdateParent(l:parent_lineno)
" endfunction


" Applies the function for each child
function! VimTodoListsForEachChild(lineno, function)
  let l:last_child_lineno = VimTodoListsFindLastChild(a:lineno)

  " Apply the function on children prior to the item.
  " This order is required for proper work of the items moving on toggle
  for current_line in range(a:lineno, l:last_child_lineno)
    call call(a:function, [current_line])
  endfor
endfunction


" Sets mapping for normal navigation and editing mode
function! VimTodoListsSetNormalMode()
  nunmap <buffer> o
  nunmap <buffer> O
  nunmap <buffer> j
  nunmap <buffer> k
  nnoremap <buffer> <leader>td :VimTodoListsToggleItemDone<CR>
  vnoremap <buffer> <leader>td :'<,'>VimTodoListsToggleItemDone<CR>
  nnoremap <buffer> <leader>tl:VimTodoListsToggleItemLater<CR>
  vnoremap <buffer> <leader>tl :'<,'>VimTodoListsToggleItemLater<CR>
  nnoremap <buffer> <leader>tw:VimTodoListsToggleItemWishlist<CR>
  vnoremap <buffer> <leader>tw :'<,'>VimTodoListsToggleItemWishlist<CR>
  nnoremap <buffer> <leader>tn:VimTodoListsToggleItemNotes<CR>
  vnoremap <buffer> <leader>tn :'<,'>VimTodoListsToggleItemNotes<CR>
  nnoremap <buffer> <leader>t?:VimTodoListsToggleItemQuestion<CR>
  vnoremap <buffer> <leader>t? :'<,'>VimTodoListsToggleItemQuestion<CR>
  nnoremap <buffer> <leader>t>:VimTodoListsToggleItemTomorrow<CR>
  vnoremap <buffer> <leader>t> :'<,'>VimTodoListsToggleItemTomorrow<CR>
  noremap <buffer> <leader>e :silent call VimTodoListsSetItemMode()<CR>
endfunction


" Sets mappings for faster item navigation and editing
function! VimTodoListsSetItemMode()
  nnoremap <buffer> j :VimTodoListsGoToNextItem<CR>
  nnoremap <buffer> k :VimTodoListsGoToPreviousItem<CR>
  nnoremap <buffer> o :VimTodoListsCreateNewItemBelow<CR>
  nnoremap <buffer> O :VimTodoListsCreateNewItemAbove<CR>
  nnoremap <buffer> <leader>to :VimTodoListsCreateEmptyLineBelow<CR>
  nnoremap <buffer> <leader>tO :VimTodoListsCreateEmptyLineAbove<CR>
  nnoremap <buffer> <leader>tc :VimTodoListsCreateNewChildItem<CR>
  nnoremap <buffer> <leader>td :VimTodoListsToggleItemDone<CR>
  vnoremap <buffer> <leader>td :VimTodoListsToggleItemDone<CR>
  nnoremap <buffer> <leader>tl :VimTodoListsToggleItemLater<CR>
  vnoremap <buffer> <leader>tl :VimTodoListsToggleItemLater<CR>
  nnoremap <buffer> <leader>tw :VimTodoListsToggleItemWishlist<CR>
  vnoremap <buffer> <leader>tw :VimTodoListsToggleItemWishlist<CR>
  nnoremap <buffer> <leader>tn :VimTodoListsToggleItemNotes<CR>
  vnoremap <buffer> <leader>tn :VimTodoListsToggleItemNotes<CR>
  nnoremap <buffer> <leader>t? :VimTodoListsToggleItemQuestion<CR>
  vnoremap <buffer> <leader>t? :VimTodoListsToggleItemQuestion<CR>
  nnoremap <buffer> <leader>t> :VimTodoListsToggleItemTomorrow<CR>
  vnoremap <buffer> <leader>t> :VimTodoListsToggleItemTomorrow<CR>
  inoremap <buffer> <CR> <CR><ESC>:VimTodoListsCreateNewItem<CR>
  noremap <buffer> <leader>e :silent call VimTodoListsSetNormalMode()<CR>
endfunction


" Creates a new item above the current line
function! VimTodoListsCreateNewItemAbove()
  normal! O  [ ]
  startinsert!
endfunction


" Creates a new item below the current line
function! VimTodoListsCreateNewItemBelow()
  normal! o  [ ]
  startinsert!
endfunction

" Creates a new empty line above the current line
function! VimTodoListsCreateEmptyLineAbove()
  normal! O
endfunction

" Creates a new empty line below the current line
function! VimTodoListsCreateEmptyLineBelow()
  normal! o
endfunction

" Creates a new child below the current line
function! VimTodoListsCreateNewChildItem()
  normal! o      [ ]
  startinsert!
endfunction


" Creates a new item in the current line
function! VimTodoListsCreateNewItem()
  normal! 0i  [ ]
  startinsert!
endfunction


" Moves the cursor to the next item
function! VimTodoListsGoToNextItem()
  normal! $
  " exec '/^\s*\[.\]'
  exec '/^\s*'
  silent! exec 'noh'
  normal! lll
endfunction


" Moves the cursor to the previous item
function! VimTodoListsGoToPreviousItem()
  normal! 0
  " silent! exec '?^\s*\[.\]'
  silent! exec '?^\s*'
  silent! exec 'noh'
  normal! lll
endfunction


" Toggles todo list item done
function! VimTodoListsToggleItemDone()
  let l:line = getline('.')
  let l:lineno = line('.')

  " Store current cursor position
  let l:cursor_pos = getcurpos()

  if VimTodoListsItemIsNotMarked(l:line) == 1
    call VimTodoListsForEachChild(l:lineno, 'VimTodoListsSetItemDone')
    " call VimTodoListsMoveSubtreeDown(l:lineno)
  elseif VimTodoListsItemIsDone(l:line) == 1
    call VimTodoListsForEachChild(l:lineno, 'VimTodoListsSetItemNotDone')
    " call VimTodoListsMoveSubtreeUp(l:lineno)
  endif

  " call VimTodoListsUpdateParent(l:lineno)

  " Restore the current position
  " Using the {curswant} value to set the proper column
  call cursor(l:cursor_pos[1], l:cursor_pos[4])
endfunction

" Toggles todo list item Later
function! VimTodoListsToggleItemLater()
  let l:line = getline('.')
  let l:lineno = line('.')

  " Store current cursor position
  let l:cursor_pos = getcurpos()

  if VimTodoListsItemIsNotMarked(l:line) == 1
    call VimTodoListsForEachChild(l:lineno, 'VimTodoListsSetItemLater')
    " call VimTodoListsMoveSubtreeDown(l:lineno)
  elseif VimTodoListsItemIsLater(l:line) == 1
    call VimTodoListsForEachChild(l:lineno, 'VimTodoListsSetItemNotLater')
    " call VimTodoListsMoveSubtreeUp(l:lineno)
  endif

  " call VimTodoListsUpdateParent(l:lineno)

  " Restore the current position
  " Using the {curswant} value to set the proper column
  call cursor(l:cursor_pos[1], l:cursor_pos[4])
endfunction

" Toggles todo list item wishlist
function! VimTodoListsToggleItemWishlist()
  let l:line = getline('.')
  let l:lineno = line('.')

  " Store current cursor position
  let l:cursor_pos = getcurpos()

  if VimTodoListsItemIsNotMarked(l:line) == 1
    call VimTodoListsForEachChild(l:lineno, 'VimTodoListsSetItemWishlist')
  elseif VimTodoListsItemIsWishlist(l:line) == 1
    call VimTodoListsForEachChild(l:lineno, 'VimTodoListsSetItemNotWishlist')
  endif


  " Restore the current position
  " Using the {curswant} value to set the proper column
  call cursor(l:cursor_pos[1], l:cursor_pos[4])
endfunction

" Toggles todo list item notes
function! VimTodoListsToggleItemNotes()
  let l:line = getline('.')
  let l:lineno = line('.')

  " Store current cursor position
  let l:cursor_pos = getcurpos()

  if VimTodoListsItemIsNotMarked(l:line) == 1
    call VimTodoListsForEachChild(l:lineno, 'VimTodoListsSetItemNotes')
  elseif VimTodoListsItemIsNotes(l:line) == 1
    call VimTodoListsForEachChild(l:lineno, 'VimTodoListsSetItemNotNotes')
  endif

  " Restore the current position
  " Using the {curswant} value to set the proper column
  call cursor(l:cursor_pos[1], l:cursor_pos[4])
endfunction

" Toggles todo list item question
function! VimTodoListsToggleItemQuestion()
  let l:line = getline('.')
  let l:lineno = line('.')

  " Store current cursor position
  let l:cursor_pos = getcurpos()

  if VimTodoListsItemIsNotMarked(l:line) == 1
    call VimTodoListsForEachChild(l:lineno, 'VimTodoListsSetItemQuestion')
  elseif VimTodoListsItemIsQuestion(l:line) == 1
    call VimTodoListsForEachChild(l:lineno, 'VimTodoListsSetItemNotQuestion')
  endif

  " Restore the current position
  " Using the {curswant} value to set the proper column
  call cursor(l:cursor_pos[1], l:cursor_pos[4])
endfunction

" Toggles todo list item tomorrow
function! VimTodoListsToggleItemTomorrow()
  let l:line = getline('.')
  let l:lineno = line('.')

  " Store current cursor position
  let l:cursor_pos = getcurpos()

  if VimTodoListsItemIsNotMarked(l:line) == 1
    call VimTodoListsForEachChild(l:lineno, 'VimTodoListsSetItemTomorrow')
  elseif VimTodoListsItemIsTomorrow(l:line) == 1
    call VimTodoListsForEachChild(l:lineno, 'VimTodoListsSetItemNotTomorrow')
  endif

  " Restore the current position
  " Using the {curswant} value to set the proper column
  call cursor(l:cursor_pos[1], l:cursor_pos[4])
endfunction


"Plugin startup code
if !exists('g:vimtodolists_plugin')
  let g:vimtodolists_plugin = 1

  if exists('vimtodolists_auto_commands')
    echoerr 'VimTodoLists: vimtodolists_auto_commands group already exists'
    exit
  endif

  "Defining auto commands
  augroup vimtodolists_auto_commands
    autocmd!
    autocmd BufRead,BufNewFile *.todo call VimTodoListsInit()
  augroup end

  "Defining plugin commands
  command! VimTodoListsCreateNewItemAbove silent call VimTodoListsCreateNewItemAbove()
  command! VimTodoListsCreateNewItemBelow silent call VimTodoListsCreateNewItemBelow()

  command! VimTodoListsCreateEmptyLineAbove silent call VimTodoListsCreateEmptyLineAbove()
  command! VimTodoListsCreateEmptyLineBelow silent call VimTodoListsCreateEmptyLineBelow()

  command! VimTodoListsCreateNewChildItem silent call VimTodoListsCreateNewChildItem()
  command! VimTodoListsCreateNewItem silent call VimTodoListsCreateNewItem()
  command! VimTodoListsGoToNextItem silent call VimTodoListsGoToNextItem()
  command! VimTodoListsGoToPreviousItem silent call VimTodoListsGoToPreviousItem()
  command! -range VimTodoListsToggleItemDone silent <line1>,<line2>call VimTodoListsToggleItemDone()
  command! -range VimTodoListsToggleItemLater silent <line1>,<line2>call VimTodoListsToggleItemLater()
  command! -range VimTodoListsToggleItemWishlist silent <line1>,<line2>call VimTodoListsToggleItemWishlist()
  command! -range VimTodoListsToggleItemNotes silent <line1>,<line2>call VimTodoListsToggleItemNotes()
  command! -range VimTodoListsToggleItemQuestion silent <line1>,<line2>call VimTodoListsToggleItemQuestion()
  command! -range VimTodoListsToggleItemTomorrow silent <line1>,<line2>call VimTodoListsToggleItemTomorrow()
endif

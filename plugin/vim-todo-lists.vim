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

"##############################################################################"
" Plugin Init"
"##############################################################################"

command! -range -nargs=0 Strikethrough   call s:CombineSelection(<line1>, <line2>, '0336')

function! s:CombineSelection(line1, line2, cp)
  execute 'let char = "\u'.a:cp.'"'
  execute a:line1.','.a:line2.'s/\%V[^[:cntrl:]]/&'.char.'/ge'
endfunction

" Initializes plugin settings and mappings
function! Init()
  set filetype=todo
  set foldlevel=0
  set nonumber
  set norelativenumber
  setlocal tabstop=2
  setlocal shiftwidth=2 expandtab
  setlocal cursorline
  setlocal noautoindent
  colorscheme todo

  noremap <Up> <NOP>
  noremap <Down> <NOP>
  noremap <Left> <NOP>
  noremap <Right> <NOP>
  
  noremap h <NOP>
  noremap l <NOP>

  nnoremap h zc
  nnoremap l zo
  
  nmap <leader>t-1 :vs yesterday.todo<cr>
  nmap <leader>t1 :vs tomorrow.todo<cr>
  nmap <leader>later :vs later.todo<cr>
  nmap <leader>wish :vs wishlist.todo<cr>

  if exists('g:CustomKeyMapper')
    try
      call call(g:CustomKeyMapper, [])
    catch
      echo 'VimTodoLists: Error in custom key mapper.'
           \.' Falling back to default mappings'
      call SetItemMode()
    endtry
  else
    call SetItemMode()
  endif

endfunction


"##############################################################################"
" Plugin Mappings"
"##############################################################################"


" Sets mapping for normal navigation and editing mode
function! SetNormalMode()
    nunmap <buffer> o
    nunmap <buffer> O
    nunmap <buffer> j
    nunmap <buffer> k
  
    noremap <buffer> <leader>e :silent call SetItemMode()<CR>
endfunction


" Sets mappings for faster item navigation and editing
function! SetItemMode()
    inoremap <buffer> <CR> <CR><ESC>:CreateNewItem<CR>
  
    nnoremap <buffer> o :CreateNewItemBelow<CR>
    nnoremap <buffer> O :CreateNewItemAbove<CR>
  
    nnoremap <buffer> <leader>tc :CreateNewChildItem<CR>
  
    nnoremap <buffer> j :GoToNextItem<CR>
    nnoremap <buffer> k :GoToPreviousItem<CR>
  
    nnoremap <buffer> <leader>to :CreateEmptyLineBelow<CR>
    nnoremap <buffer> <leader>tO :CreateEmptyLineAbove<CR>
  
    noremap <buffer> <leader>e :silent call SetNormalMode()<CR>
endfunction


"##############################################################################"
" Plugin Commands"
"##############################################################################"

function! GetTodoType(line)
    if strpart(a:line, 2, 3) =~? '\[.\]'
        return 'Story'
    elseif strpart(a:line, 6, 3) =~? '\[.\]'
        return 'Task'
    endif
endfunction

function! NewItemIsNotEmpty(line)
    echo a:line
    return 0
endfunction

" Creates a new item in the current line
function! CreateNewItem()
    let l:line = getline('.')
    let l:label = GetItemLabel(l:line)
    let l:type = GetTodoType(l:line)
    
    if l:type == 'Story'
        execute "normal! 0i      [ ]  | " . l:label . "\<Esc>F|1h"
    elseif l:type == 'Task' && NewItemIsNotEmpty(l:line)
        execute "normal! 0i      [ ]  | " . l:label . "\<Esc>F|1h"
    else
        execute "normal! 0i  [ ]  |\<Esc>1h"
    endif
    
    startinsert
endfunction

" Creates a new item above the current line
function! CreateNewItemAbove()
    execute "normal! O  [ ]  |\<Esc>1h"
    startinsert
endfunction

" Creates a new item below the current line
function! CreateNewItemBelow()
    execute "normal! o  [ ]  |\<Esc>1h"
    startinsert
endfunction

" Creates a new child below the current line
function! CreateNewChildItem()
    let l:line = getline('.')
    let l:split = split(l:line, ':')
    let l:lineno = line('.')
    let l:label = GetItemLabel(l:line)
    execute "normal! o      [ ]  | " . l:label . "\<Esc>F|1h"
    startinsert
    
    "if len(l:split) == 1
        "execute "normal! o" . split(l:line, '|')[0] . ":   | " . l:label . " \<Esc>F:2l"
    "else
        "execute "normal! o" . l:split[0] . ":   | " . l:label . " \<Esc>F:2l"
    "endif
    
endfunction

" Creates a new empty line above the current line
function! CreateEmptyLineAbove()
    normal! O
endfunction

" Creates a new empty line below the current line
function! CreateEmptyLineBelow()
    normal! o
endfunction

" Moves the cursor to the next item
function! GoToNextItem()
    normal! $
    exec '/^\s*\[.\]'
    " exec '/^\s*'
    silent! exec 'noh'
    normal! lll
endfunction

" Moves the cursor to the previous item
function! GoToPreviousItem()
    normal! 0
    silent! exec '?^\s*\[.\]'
    " silent! exec '?^\s*'
    silent! exec 'noh'
    normal! lll
endfunction


"##############################################################################"
" Plugin Utils"
"##############################################################################"

" Returns label of a task
function! GetItemLabel(line)
    return matchstr(a:line, '@\w*')
endfunction


"##############################################################################"
" Plugin Startup Code"
"##############################################################################"


if !exists('g:vimtodolists_plugin')
    let g:vimtodolists_plugin = 1

    if exists('vimtodolists_auto_commands')
        echoerr 'VimTodoLists: vimtodolists_auto_commands group already exists'
        exit
    endif

    "Defining auto commands
    augroup vimtodolists_auto_commands
        autocmd!
        autocmd BufRead,BufNewFile *.todo call Init()
    augroup end

    "Defining plugin commands
    command! CreateNewItem silent call CreateNewItem()
  
    command! CreateNewItemAbove silent call CreateNewItemAbove()
    command! CreateNewItemBelow silent call CreateNewItemBelow()
  
    command! CreateNewChildItem silent call CreateNewChildItem()

    command! CreateEmptyLineAbove silent call CreateEmptyLineAbove()
    command! CreateEmptyLineBelow silent call CreateEmptyLineBelow()

    command! GoToNextItem silent call GoToNextItem()
    command! GoToPreviousItem silent call GoToPreviousItem()

endif

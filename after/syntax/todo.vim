"Syntax commands ordering is important due to order of the matching
syntax match vimTodoListsTodo '^\s*\[ \].*[^@]+'
syntax match vimTodoListsDone '^\s*\[X\].*'
syntax match vimTodoListsLater '^\s*\[L\].*'
syntax match vimTodoListsWishlist '^\s*\[W\].*'
syntax match vimTodoListsNotes '^\s*\[N\].*'
syntax match vimTodoListsQuestions '^\s*\[?\].*'
syntax match vimTodoListsLabelWork '@work'
syntax match vimTodoListsLabelOSS '@oss'
syntax match vimTodoListsLabelPersonal '@personal'
syntax match vimTodoListsLabelHousehold '@household'
syntax match vimTodoListsLabelEstimate '$.* '

highlight link vimTodoListsTodo Todo
highlight link vimTodoListsDone Done
highlight link vimTodoListsLater Later
highlight link vimTodoListsWishlist Wishlist
highlight link vimTodoListsNotes Notes
highlight link vimTodoListsQuestions Question
highlight link vimTodoListsLabelWork labelwork
highlight link vimTodoListsLabelOSS labeloss
highlight link vimTodoListsLabelPersonal labelpersonal
highlight link vimTodoListsLabelHousehold labelhousehold
highlight link vimTodoListsLabelEstimate labelestimate

" Vim filetype plugin file
" Language:     Madlib
" Maintainer:   open-sorcerers
" URL:          https://github.com/open-sorcerers/vim-madlib

setlocal iskeyword+=$ suffixesadd+=.mad

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | setlocal iskeyword< suffixesadd<'
else
  let b:undo_ftplugin = 'setlocal iskeyword< suffixesadd<'
endif

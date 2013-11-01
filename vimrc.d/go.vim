" A Go bundle for Vundle or Pathogen
Bundle 'Blackrush/vim-gocode'

autocmd FileType go call SuperTabSetDefaultCompletionType('<c-x><c-o>')

" Temporary for for this issue https://github.com/Blackrush/vim-gocode/issues/4
autocmd FileType go autocmd BufWritePre <buffer> :keepjumps Fmt

" This plugin adds godef support to vim.
Bundle 'dgryski/vim-godef'
let g:godef_split=0
Plug 'python.vim'
Plug 'satyrius/python-syntax.vim'

let python_highlight_all=1
let NERDTreeIgnore+=['\.pyc$', '__pycache__$[[dir]]', '\.egg-info$[[dir]]']
set wildignore+=*.pyc,.noseids,.ropeproject,pyenv,__pycache__,*.egg-info

augroup my_python
    autocmd!
    autocmd FileType python setlocal colorcolumn=80
    autocmd FileType python :iabbrev <buffer> putf # coding=utf-8
    autocmd FileType python :iabbrev <buffer> ipdb import ipdb; ipdb.set_trace()
augroup END

if has('python')

function! HasPythonModule(name)
python << EOF
import vim
try:
    __import__(vim.eval('a:name'))
    vim.command('return 1')
except ImportError:
    vim.command('return 0')
EOF
endfunction

" Flake8 is a wrapper around PyFlakes (static syntax checker), PEP8 (style
" checker) and Ned's MacCabe script (complexity checker).
"
" `pyflakes` python module is required:
"
"     pip install pyflakes
"
if HasPythonModule('pyflakes')
    Plug 'nvie/vim-flake8'
    let g:flake8_ignore="E501" " ignore long lines check
    augroup my_flake8
        autocmd!
        autocmd BufWritePost *.py call Flake8()
    augroup END
endif

" jedi-vim is a is a VIM binding to the autocompletion library Jedi.
"
" `jedi` python module is required:
"
"     pip install jedi
"
if HasPythonModule('jedi')
    Plug 'davidhalter/jedi-vim'
    let g:jedi#use_tabs_not_buffers = 0
    let g:jedi#popup_on_dot = 0
    let g:jedi#goto_definitions_command = 'gd'
    augroup my_jedi
        autocmd!
        autocmd FileType python call SuperTabSetDefaultCompletionType('<c-x><c-o>')
    augroup END
endif

" Activate current virtual environment
    python << EOF
import os, sys
ve_dir = os.environ.get('VIRTUAL_ENV')
if ve_dir:
    ve_dir in sys.path or sys.path.insert(0, ve_dir)
    activate = os.path.join(ve_dir, 'bin', 'activate_this.py')
    execfile(activate, dict(__file__=activate))
EOF

endif

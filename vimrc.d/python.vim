Plug 'vim-scripts/python.vim'
Plug 'hdima/python-syntax'

let python_highlight_all=1
set wildignore+=*.pyc,.noseids,.ropeproject,__pycache__,*.egg-info

augroup my_python
    autocmd!
    autocmd FileType python setlocal softtabstop=4 shiftwidth=4 tabstop=4 colorcolumn=80
    autocmd FileType python :iabbrev <buffer> putf # coding=utf-8
    autocmd FileType python :iabbrev <buffer> ipdb import ipdb; ipdb.set_trace()
augroup END

if has('python3')

function! HasPythonModule(name)
python3 << EOF
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

    " Load this after jedi
    Plug 'lambdalisue/vim-pyenv'
    let g:jedi#force_py_version = 3
    " function! s:jedi_auto_force_py_version() abort
    "     let major_version = pyenv#python#get_internal_major_version()
    " endfunction
    " augroup vim-pyenv-custom-augroup
    "     autocmd! *
    "     autocmd User vim-pyenv-activate-post   call s:jedi_auto_force_py_version()
    "     autocmd User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
    " augroup END
endif

" Activate current virtual environment
    python3 << EOF
import os, sys


def init_ve():
    ve_dir = os.environ.get('VIRTUAL_ENV')
    if not ve_dir:
        return
    ve_dir in sys.path or sys.path.insert(0, ve_dir)
    current_dir = os.getcwd()
    if "/projects/" not in current_dir:
        return
    dirs = current_dir.split("/projects/")
    if len(dirs) == 1:
        return
    venv_dir = dirs[1].split("/")[0]
    activate = "{}-venv".format(os.path.join(ve_dir, venv_dir, 'bin', 'activate_this.py'))
    if os.path.exists(activate):
        code = compile(open(activate).read(), activate, 'exec')
        exec(code, {"__file__": activate}, {})



init_ve()
EOF
endif

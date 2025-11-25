""" This was here when I got here, probably no touchy
" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

""" Vim config stuff (Pre-Startup)
" Save backup/swap/undo files to central location
let &backupdir='C:\Users\caasi\vimfiles\tmp'
let &directory='C:\Users\caasi\vimfiles\tmp'
let &undodir='C:\Users\caasi\vimfiles\tmp'

" Set the default python to python3
let g:pymode_python = 'python3'
let &pythonthreedll='D:\Program Files\Python310\Python310.dll'
let &pythonthreehome='D:\Program Files\Python310'
" let &pythonthreedll='C:\Users\Isaac\AppData\Local\Programs\Python\Python310\Python310.dll'
" let &pythonthreehome='C:\Users\Isaac\AppData\Local\Programs\Python\Python310'

set encoding=utf-8
set autoread " Automatically reload file after changes

""" Appearance (and other startup things)
" Maximize the window
au GUIEnter * simalt ~x

" Set the color scheme
colorscheme isaaccolor

" Set the font
if has("gui_running")
    " set guifont=Lucida_Console:h10:cANSI:qDRAFT
    set guifont=Lucida_Sans_Typewriter:h10:cANSI:qDRAFT
endif

" Turn on relative numbering when in normal or visual mode, go to normal numbering in insert
" or when away from the window
set number
augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu | endif
	autocmd BufLeave,FocusLost,InsertEnter,WinLeave * if &nu | set nornu | endif
augroup END

" Start in root directory of D, makes it easier to find files in current environment
cd C:\

" Tab settings
set tabstop=4
set shiftwidth=4
set expandtab

""" Plugin management
" Add/Enable Plugins
call plug#begin()
Plug 'preservim/nerdtree' |
    \ Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-scripts/indentpython.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'dense-analysis/ale'
Plug 'junegunn/vim-easy-align'
Plug 'Konfekt/FastFold'
Plug 'Valloric/YouCompleteMe'
call plug#end()

" EasyAlign Plugin Config
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" vim-gitgutter Plugin Config
set updatetime=100
set signcolumn=yes
highlight SignColumn guibg=bg
let g:gitgitter_set_sign_backgrounds = 1

" YouCompleteMe Plugin Config
let g:ycm_python_interpreter_path="C:/Program Files/Python310/python.exe"
" let g:ycm_python_sys_path = [
"     \ "C:\\opt\\ros\\foxy\\x64\\Lib\\site-packages",
" \]
" let g:ycm_extra_conf_vim_data = [
"     \ 'g:ycm_python_interpreter_path',
"     \ 'g:ycm_python_sys_path'
" \]
" let g:ycm_global_ycm_extra_conf = '%VIM%\global_extra_conf.py'
hi link YcmErrorLine error
let g:ycm_always_populate_location_list = 1
let g:ycm_auto_hover = ''
nmap <leader>i <plug>(YCMHover)
nmap <leader>s <plug>(YCMFindSymbolInWorkspace)
nmap <leader>r :YcmCompleter RefactorRename 
nmap <silent> <leader><tab> :YcmCompleter GoTo<cr>
nmap <silent> <leader>f :YcmCompleter FixIt<cr>
nmap <leader>d <plug>(YcmShowDetailedDiagnostic)<cr>
let g:ycm_disable_signature_help = 0
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_clangd_args=['--header-insertion=never']

" vim-fugitive Plugin Config
nnoremap <leader>g :Git<cr> :resize 20<cr>

" ale Plugin Config
let g:ale_linters = {
            \ 'python': ['flake8'],
\}
let g:ale_python_flake8_options = '--ignore=E501'
let g:ale_linters_explicit = 1
let g:ale_set_signs = 0
let g:ale_set_highlights = 1
hi link ALEWarningLine spellcap
hi link ALEErrorLine error

" NERDTree Plugin Config
" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeShowLineNumbers = 1
" Shortcut to reopen NERDTree
noremap <silent> <leader>n :NERDTree<CR>

" Misc
autocmd BufEnter *.urdf setf xml

""" Hotkey reconfig for while running
" Use ctrl+k to apply clang formatting
map <C-K> :py3f D:/Program Files/LLVM/share/clang/clang-format.py<cr>

" Use \\ to clear search highlighting
nnoremap <silent> <leader>\ :noh<return>
" Use \c to CD to the current file's directory
nnoremap <silent> <leader>c :cd %:p:h<return>


" Ctrl+Backspace to delete previous word
imap <C-BS> <C-W>
set backspace=indent,eol,start

" Delete without yanking
nnoremap d "_d
vnoremap d "_d

" Replace currently selected text with the default register
" without yanking it
vnoremap p "_dP

" Movement
noremap <silent> gb ^
noremap <silent> [e :lnext<CR>
noremap <silent> ]e :lprev<CR>
noremap <silent> [a :ALENext<cr>
noremap <silent> ]a :ALEPrev<cr>

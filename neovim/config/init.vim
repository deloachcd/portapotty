""" Vim 8 / Neovim configuration section
set nu rnu                                  " hybrid line numbers
set t_Co=256                                " truecolor
set scrolloff=3                             " scroll padding
call matchadd('ColorColumn', '\%80v', 100)  " highlight column 80
set tabstop=8                               " hard tabs are 8 spaces wide
set shiftwidth=4                            " 4-space wide indents
set expandtab                               " hitting "tab" inserts spaces

""" Plugin listing section
call plug#begin('~/.vim/plugged')
  " plugins written by other people
  Plug 'tpope/vim-sensible'
  Plug 'ciaranm/detectindent'
  Plug 'tpope/vim-surround'
  "Plug 'tpope/vim-commentary'
  Plug 'vim-syntastic/syntastic'
  "Plug 'preservim/nerdtree'
  Plug 'inkarkat/SyntaxAttr.vim'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'wincent/terminus'
  Plug 'deloachcd/nord-vim'
  " plugins written by me
  Plug 'mildewchan/takodachi.vim'
  Plug 'mildewchan/atlantean.vim'
call plug#end()

""" plugin configuration
let g:syntastic_cpp_include_dirs = [
      \ $HOME."/.local/include/syntastic-headers"
      \ ]

""" color config
colorscheme nord

""" themed statusline
function! g:StatuslineMode()
  let l:mode_map = {
    \ 'n': 'NORMAL', 'i': 'INSERT', 'R': 'REPLACE',
    \ 'v': 'VISUAL', 'V': 'V-LINE', "\<C-v>": 'V-BLOCK',
    \ 'c': 'COMMAND', 's': 'SELECT', 'S': 'S-LINE',
    \ "\<C-s>": 'S-BLOCK', 't': 'TERMINAL',
    \   }
  return get(l:mode_map, mode(), "BLACK MAGIC")
endfunction
set statusline=%1*\ %{StatuslineMode()}\ >>%2*\ %f\ %m\ %r%=\ %{&ff}\ \|\ 
set statusline+=%{strlen(&fenc)?&fenc:'none'}\ \|\ %{&filetype}\ <<
set statusline+=%3*\ %l:%L\ 
set laststatus=2
set noshowmode

" mappings 
inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
map -a	:call SyntaxAttr#SyntaxAttr()<CR>
map -t	:NERDTreeToggle<CR>
map -d	:DetectIndent<CR>

"" helper functions
function! StatuslineGitBranch()
  let b:gitbranch=""
  if &modifiable
    try
      let l:dir=expand('%:p:h')
      let l:gitrevparse = system("git -C ".l:dir." rev-parse --abbrev-ref HEAD")
      if !v:shell_error
        let b:gitbranch="(".substitute(l:gitrevparse, '\n', '', 'g').") "
      endif
    catch
    endtry
  endif
endfunction

augroup GetGitBranch
  autocmd!
  autocmd VimEnter,WinEnter,BufEnter * call StatuslineGitBranch()
augroup END

" Source: https://vim.fandom.com/wiki/Autocomplete_with_TAB_when_typing_words
function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction
"set dictionary="/usr/dict/words"

""" abbreviations
func Eatchar(pat)
  " some black magic from the help manual to remove trailing
  " spaces from abbreviations. to use it, append this directly
  " to the end of an abbreviation definition:
  " <C-R>=Eatchar('\s')<CR>
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc
"python
autocmd Filetype python :iabbrev im import
autocmd Filetype python :iabbrev ifn if<Space>__name__<Space>==<Space>"__main__":<CR><C-R>=Eatchar('\s')<CR>
autocmd Filetype python :iabbrev pr print("")<left><left><C-R>=Eatchar('\s')<CR>

""" ugly hacks
if has('nvim')
    " some nasty shit to fix <c-h> in neovim
    nmap <BS> <C-W>h  
endif

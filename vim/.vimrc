if !isdirectory(glob('~/.vim/plugged'))
	"Install vim-plug
	silent execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdcommenter' "easier commenting
Plug 'terryma/vim-multiple-cursors' "multiple cursors
Plug 'honza/vim-snippets' "snippets
Plug 'tpope/vim-surround' "surround commands
Plug 'easymotion/vim-easymotion' "even faster movement
Plug 'tpope/vim-fugitive' "handy git tools
Plug 'markonm/traces.vim' "pattern preview
Plug 'vimpostor/vim-prism' "colorscheme
Plug 'https://gitlab.com/dbeniamine/cheat.sh-vim.git' "cheat sheets
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'puremourning/vimspector' "debugging
Plug 'vimpostor/vim-tpipeline' "outsource statusline to tmux
call plug#end()

"color scheme
set background=dark
silent! colorscheme prism
"general vim options
set noswapfile "no swap
set updatetime=300 "updatetime for CursorHold
set timeoutlen=1000 "mapping delays
set ttimeoutlen=10 "keycode delays
set cursorline "highlight current line
set guicursor=
set confirm "Ask to confirm instead of failing
set ignorecase "case insensitive search
set smartcase "case sensitive if search term contains capitals
set hlsearch "highlight search
set incsearch "highlight while you type
set scrolloff=4 "start scrolling a few lines from the border
set display+=lastline "always display the last line of the screen
set showmatch "when inserting brackets, highlight the matching one
syntax enable
set wildmenu "better tab completion
set wildmode=longest:full,full
set ttyfast "fast terminal connection
set gdefault "replace globally by default
set encoding=utf-8 "latin1? what year is it? fuckin 1991?
set autoindent
set smartindent
set noexpandtab
set shiftwidth=4 "tab = 4 spaces
set tabstop=4
silent! set stl=%!tpipeline#stl#line()
set laststatus=2 "always show the statusline
set noshowmode "dont show mode
set noruler "no curser position
set noshowcmd "don't show cmds
set mouse=a "enable mouse input
set t_ut="" "prevents a weird background on some terminals
set lazyredraw
set hidden "allow buffers to be hidden
set shortmess+=c "don't give ins-completion-menu messages
set shortmess-=S "show number of search matches
"do not write backup files, they cause more problems than they solve
set nobackup
set nowritebackup
if has('termguicolors') "true colors
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	set termguicolors
endif
"keep selected text selected when indenting
vnoremap < <gv
vnoremap > >gv
"allow completions from the dictionary
set complete+=kspell
set diffopt+=vertical

"file type specific settings
autocmd Filetype yaml setlocal ts=2 sw=2 et
autocmd Filetype tex setlocal conceallevel=1 spell
autocmd Filetype markdown setlocal spell
autocmd Filetype gitcommit setlocal spell
au BufRead /tmp/mutt-* setlocal fo+=aw spell spelllang=en,de
autocmd FileType haskell setlocal expandtab
"switch between header and source
func HeaderToggle()
	let l:f = expand("%<")
	let l:e = expand("%:e")
	let l:h = ['hpp', 'h', 'hh', 'hxx']
	let l:s = ['cpp', 'c', 'cc', 'cxx']
	let l:i = index(l:h, l:e)
	let l:l = l:h
	if index(l:s, l:e) == -1
		let l:l = l:s
	endif
	for i in l:l
		if filereadable(l:f . '.' . i)
			exe 'e ' . l:f . '.' . i
			return
		endif
	endfor
endfunc
autocmd Filetype cpp,c nnoremap <silent> <F4> :call HeaderToggle()<CR>

"pandoc
command PandocDisable autocmd! Pandoc BufWritePost *
command PandocEnable exe 'silent! PandocDisable!' | exe 'augroup Pandoc' | exe 'silent !pandoc % -o /tmp/%:t.pdf && xdg-open /tmp/%:t.pdf' | exe 'autocmd BufWritePost * silent! !pandoc % -o /tmp/%:t.pdf' | exe 'augroup END' | exe 'redraw!'

"general keybindings
let mapleader = ","
let maplocalleader = " "
map j gj
map k gk
nnoremap Q @@ "last macro
"Use the system clipboard only when explicitly yanking
xnoremap y "+y
nnoremap y "+y
nnoremap p "+p
nnoremap P "+P
nnoremap Y y$
"move lines around
nnoremap <silent> J :<C-U>exec "exec 'norm m`' \| move +" . (0+v:count1)<CR>==``
nnoremap <silent> K :<C-U>exec "exec 'norm m`' \| move -" . (1+v:count1)<CR>==``
vnoremap <silent> J :<C-U>exec "'<,'>move '>+" . (0+v:count1)<CR>gv=gv
vnoremap <silent> K :<C-U>exec "'<,'>move '<-" . (1+v:count1)<CR>gv=gv
"clear search
nnoremap <silent> <LocalLeader>/ :nohl<CR>
"autocorrect last misspelling
imap <c-v> <c-g>u<Esc>[s1z=`]a<c-g>u
"Thesaurus
nnoremap <silent> <LocalLeader>t :call popup_atcursor(split(system('aiksaurus '.shellescape(substitute(expand('<cWORD>'), '[^[:alpha:]]', '', 'g'))), '\n')[:-2], #{title: expand('<cWORD>'), border: [], col: min([col('.')%&columns, &columns/2])})<CR>
"do not overwrite my keybindings in rebase mode
let g:no_gitrebase_maps = 1
"write with sudo
command SudoWrite w !sudo tee "%" > /dev/null

"netrw
nnoremap <silent> <C-t> :Lexplore<CR>
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_winsize = 25

"plugin settings
"coc.nvim
"extensions
let g:coc_global_extensions = [
\ 'coc-snippets',
\ 'coc-texlab',
\ 'coc-python',
\ 'coc-json',
\ 'coc-yaml',
\ 'coc-lists',
\ 'coc-clangd',
\ 'coc-rust-analyzer',
\ ]
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> <LocalLeader>K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
autocmd CursorHold * silent call CocActionAsync('highlight') "highlight symbol on cursor hold
nmap <leader>rn <Plug>(coc-rename)
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
augroup mygroup
  autocmd!
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected') "Setup formatexpr specified filetype(s).
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp') "Update signature help on jump placeholder
augroup end
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>ac  <Plug>(coc-codeaction)
nmap <leader>qf  <Plug>(coc-fix-current)
"function text objects
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
xmap <silent> <Tab> <Plug>(coc-range-select)
command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call CocAction('fold', <f-args>)
nnoremap <silent> <LocalLeader>e  :<C-u>CocList diagnostics<cr>
nnoremap <silent> <LocalLeader>c  :<C-u>CocList commands<cr>
nnoremap <silent> <LocalLeader>o  :<C-u>CocList outline<cr>
nnoremap <silent> <LocalLeader>s  :<C-u>CocList -I symbols<cr>
nnoremap <silent> <LocalLeader>j  :<C-u>CocNext<CR>
nnoremap <silent> <LocalLeader>k  :<C-u>CocPrev<CR>
nnoremap <silent> <LocalLeader>p  :<C-u>CocListResume<CR>
"snippets
imap <C-j> <Plug>(coc-snippets-expand-jump)
"lists
nnoremap <silent> <LocalLeader>P :<C-u>CocList -A files<CR>
nnoremap <silent> <LocalLeader>b :<C-u>CocList -A buffers<CR>
nnoremap <silent> <LocalLeader>f :<C-u>CocList -A -I grep<CR>
"coc-texlab
nnoremap <silent> <LocalLeader>ll :<C-u>CocCommand latex.Build<CR>
nnoremap <silent> <LocalLeader>lv :<C-u>CocCommand latex.ForwardSearch<CR>

"vimspector
let g:vimspector_enable_mappings = 'HUMAN'
nmap <Leader>di <Plug>VimspectorBalloonEval
xmap <Leader>di <Plug>VimspectorBalloonEval
nmap <LocalLeader><F11> <Plug>VimspectorUpFrame
nmap <LocalLeader><F12> <Plug>VimspectorDownFrame

"easy motion
nmap s <Plug>(easymotion-s2)
nmap t <Plug>(easymotion-t2)
map <Leader> <Plug>(easymotion-prefix)
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
let g:EasyMotion_startofline = 0 "keep cursor column when JK motion
hi link EasyMotionTarget2First Search
hi link EasyMotionTarget2Second ErrorMsg
let g:EasyMotion_keys = "asdghklqwertyuiopzxcvbnmfj,"

"multiple cursors
let g:multi_cursor_exit_from_insert_mode = 0

"tpipeline
let g:tpipeline_cursormoved = 1

"nerdcommenter
let g:NERDSpaceDelims = 1

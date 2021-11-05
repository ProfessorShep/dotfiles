" Set leader
let mapleader=" "
" Auto install vim plugins

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'

if empty(glob(data_dir . '/autoload/plug.vim'))

    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC

endif

autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Vim plugins

call plug#begin(stdpath('data') . '/plugged')

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'kana/vim-textobj-user' | Plug 'kana/vim-textobj-entire'
Plug 'machakann/vim-highlightedyank'
Plug 'lervag/vimtex'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'vim-airline/vim-airline'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'joshdick/onedark.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'mfussenegger/nvim-jdtls'
Plug 'simrat39/rust-tools.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'mfussenegger/nvim-dap'
Plug 'nvim-telescope/telescope.nvim'
Plug 'williamboman/nvim-lsp-installer'
Plug 'ms-jpq/coq.nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'windwp/nvim-autopairs'

call plug#end()

" Some `set`s
set tabstop=4
set shiftwidth=4
set mouse=a
set noshowmode
set termguicolors
set number

" Colorizer
lua require'colorizer'.setup()

" Spell Checking
set spell spelllang=en_us

" Syntax Highlighting
syntax on
colorscheme onedark

" LSP

lua << EOF
local lsp_installer = require "nvim-lsp-installer"

lsp_installer.on_server_ready(function(server)
	server:setup(require "coq".lsp_ensure_capabilities())
end)
	
EOF

" Telescope
lua require "telescope".load_extension("fzf")
nnoremap <C-P> <cmd>Telescope find_files<cr>
inoremap <C-P> <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Other
lua require 'nvim-autopairs'.setup{}
lua require("rust-tools").setup({})
let g:coq_settings = { 'auto_start': 'shut-up' }

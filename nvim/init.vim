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
Plug 'nvim-treesitter/nvim-treesitter'

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

let g:coq_settings = { 'auto_start': 'shut-up' }
lua << EOF
local coq = require "coq"
local lsp = require "lspconfig"

function setup(server)
	server.setup(coq.lsp_ensure_capabilities())
end

setup(lsp.bashls)
setup(lsp.yamlls)
setup(lsp.vimls)
setup(lsp.pyright)
setup(lsp.rust_analyzer)
setup(lsp.clangd)
setup(lsp.jdtls)
setup(lsp.html)
setup(lsp.cssls)
setup(lsp.ltex)
setup(lsp.tsserver)
setup(lsp.cmake)
setup(lsp.jsonls)

EOF

" Treesitter
lua << EOF
require "nvim-treesitter.configs".setup {
	highlight = {
		enable = true
	},
	indent = {
		enable = true
	}
}
EOF

" Telescope
nnoremap <C-P> <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
inoremap <C-P> <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
inoremap <C-@> <C-Space>
nnoremap P <cmd>Telescope lsp_code_actions<cr>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>jr <cmd>Telescope lsp_references<cr>
nnoremap <leader>jd <cmd>Telescope lsp_definitions<cr>

" Other keybindings
nnoremap <leader>rr <cmd>lua vim.lsp.buf.rename()<cr>
nnoremap <silent> <leader>= <cmd>lua vim.lsp.buf.formatting()<cr>
nnoremap <silent> <leader>i <cmd>lua vim.lsp.buf.hover()<cr>
" Other
autocmd! User nvim-autopairs lua require 'nvim-autopairs'.setup{}
autocmd! User rust-tools lua require("rust-tools").setup({})

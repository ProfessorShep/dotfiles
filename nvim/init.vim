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

Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'vim-airline/vim-airline'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'joshdick/onedark.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'ms-jpq/coq.nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'windwp/nvim-autopairs'
Plug 'nvim-treesitter/nvim-treesitter'


call plug#end()

" Some `set`s
set expandtab
set tabstop=2
set shiftwidth=2
set mouse=a
set noshowmode
set autoindent
set termguicolors
set number
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99
set syntax=off

" Colorizer
lua require'colorizer'.setup()

" Spell Checking
set spell spelllang=en_us

" Color Scheme
colorscheme onedark

" LSP

let g:coq_settings = { 'auto_start': 'shut-up' }
lua << EOF
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('i', '<F2>', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, bufopts)
end
local coq = require "coq"
local lsp = require "lspconfig"

-- Implement switch header/source files for clangd
local clangd_switch_source_header = function(buffer)
  local handler = function(err, result, ctx, config)
    if err ~= nil then
      vim.cmd('echo \'Failed to switch files, LSP error' .. err.message .. '\'')
    elseif (result == '' or result == nil) then
      vim.cmd('echo \'Failed to find file to switch to\'')
    else
      vim.cmd('e ' .. result)
    end

  end

  local current_file = vim.fn.expand('%:p')
  vim.lsp.buf_request(buffer, 'textDocument/switchSourceHeader', {uri =  'file:///' .. current_file }, handler )
end

function setup(server)
  local attach_handler = on_attach;

  if (server == lsp.clangd) then
    -- Attach clangd switch header/source
    attach_handler = function(client, bufnr)
      on_attach(client, bufnr)

      vim.keymap.set('n', '<F4>', clangd_switch_source_header, bufopts)
      vim.keymap.set('i', '<F4>', clangd_switch_source_header, bufopts)
    end
  end

	server.setup(coq.lsp_ensure_capabilities({on_attach = attach_handler}))
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

-- Fix treesitter folding for telescope
vim.api.nvim_create_autocmd('BufRead', {
   callback = function()
      vim.api.nvim_create_autocmd('BufWinEnter', {
         once = true,
         command = 'normal! zx'
      })
   end
})

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
lua << EOF
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ['<esc>'] = require('telescope.actions').close
      }
    },
	  file_ignore_patterns = {
		  ".git",
		  ".cache",
		  "out",
		  ".vs",
		  ".qtc-clangd",
		  "build",
		  ".kdev4",
		  "%.o",
		  "%.a",
		  "%.class",
	  }
  }
}


EOF

nnoremap <C-K> <cmd>Telescope find_files<cr>
inoremap <C-K> <cmd>Telescope find_files<cr>
nnoremap <C-P> <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
inoremap <C-P> <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
inoremap <C-@> <C-Space>
nnoremap <leader>fc <cmd>Telescope lsp_code_actions<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fr <cmd>Telescope lsp_references<cr>
nnoremap <leader>fd <cmd>Telescope lsp_definitions<cr>

" Other keybindings
nnoremap <leader>rr <cmd>lua vim.lsp.buf.rename()<cr>
nnoremap <silent> <leader>= <cmd>lua vim.lsp.buf.formatting()<cr>
nnoremap <silent> <leader>i <cmd>lua vim.lsp.buf.hover()<cr>
" Other
autocmd! User nvim-autopairs lua require 'nvim-autopairs'.setup{}
autocmd! User rust-tools lua require("rust-tools").setup({})

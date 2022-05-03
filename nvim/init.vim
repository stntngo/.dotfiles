" TODO: (niels) Get rid of all of this legacy vimscript and use something like packer to handle packages from inside fennel.
call plug#begin()

Plug 'echasnovski/mini.nvim', { 'branch': 'stable' }
Plug 'svermeulen/vimpeccable'

" Visuals
Plug 'EdenEast/nightfox.nvim'
Plug 'cocopon/iceberg.vim'
Plug 'shaunsingh/nord.nvim'

Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" Universal Plugins
Plug 'direnv/direnv.vim'
Plug 'tpope/vim-commentary'
Plug 's1n7ax/nvim-terminal'

Plug 'neovim/nvim-lspconfig'
Plug 'tpope/vim-fugitive'
Plug 'mbbill/undotree'

" NOTE: This might causing a high amount of memory usage in the go-code monorepo.
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'stevearc/dressing.nvim'
Plug 'folke/todo-comments.nvim'

" XXX: Candidate for deletion
Plug 'nvim-lua/lsp-status.nvim'

" Completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Diagnostic
Plug 'folke/trouble.nvim'

" Language Specific Plugins

" Go
Plug 'fatih/vim-go'

" Python
" XXX: Candidate for deletion
Plug 'jmcantrell/vim-virtualenv'

" Javascript
Plug 'pangloss/vim-javascript'

" GraphQL
Plug 'jparise/vim-graphql'

" Zig
Plug 'ziglang/zig.vim'

" Elixir
Plug 'elixir-editors/vim-elixir'

" Gleam
Plug 'gleam-lang/gleam.vim'

" Rust
Plug 'rust-lang/rust.vim'

" Hashicorp
Plug 'hashivim/vim-hashicorp-tools'
Plug 'jvirtanen/vim-hcl'

" Clojure / Fennel
Plug 'Olical/conjure'
Plug 'Olical/aniseed'
Plug 'jaawerth/fennel.vim'
Plug 'PaterJason/cmp-conjure'

" Misc.
" XXX: Candidate for deletion, unless I need it to be able to edit Obsidian controlled files more easily.
Plug 'vimwiki/vimwiki'
Plug 'tsandall/vim-rego'

" Parsing
Plug 'killphi/vim-ebnf'
Plug 'dylon/vim-antlr'
Plug 'pest-parser/pest.vim'
Plug 'gf3/peg.vim'

call plug#end()

lua require('aniseed.env').init()

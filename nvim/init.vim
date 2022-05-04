" TODO: Migrate to Lua
" Get rid of all of this legacy vimscript and use something like packer to handle 
" packages from inside fennel.
call plug#begin()

" Offers general "mini" versions of other more full featured
" plugins. Currently I'm only leveraging the sessions functionality and
" barely scratching the surface of the start functionality.
Plug 'echasnovski/mini.nvim', { 'branch': 'stable' }

" Lets you write your bindings natively in Lua and avoid the awkwardness of
" vim.api.nvim_set_keymap("n", "gg", "<cmd>lua require('package').function()<cr>"
Plug 'svermeulen/vimpeccable'

" Themes and Icons
Plug 'EdenEast/nightfox.nvim'
Plug 'cocopon/iceberg.vim'
Plug 'shaunsingh/nord.nvim'
Plug 'kdheepak/monochrome.nvim'
Plug 'kyazdani42/nvim-web-devicons'

" Lua powered status line, very easy to configure and extend.
Plug 'nvim-lualine/lualine.nvim'

" Lua powered buffer "tabs" to offer quick, targeted switching between them. I
" don't know how much I actually like the buffer tab functionality or whether
" it'd be better to just use telescope for all my buffer switching needs.
Plug 'akinsho/bufferline.nvim'

" Automatically source .envrc files when moving around the file system. This
" package is extra helpful inside of neovide which I haven't been able to 
Plug 'direnv/direnv.vim'

" XXX: Candidate for deletion. Just use mini.comment instead.
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
Plug 'ThePrimeagen/git-worktree.nvim'
Plug 'folke/todo-comments.nvim'

" XXX: Candidate for deletion
Plug 'stevearc/dressing.nvim'

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
" TODO: Look into ray-x/go.nvim as a lua-based replacement.
Plug 'fatih/vim-go'

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

" Parsing
Plug 'killphi/vim-ebnf'
Plug 'dylon/vim-antlr'
Plug 'pest-parser/pest.vim'
Plug 'gf3/peg.vim'

call plug#end()

lua require('aniseed.env').init()

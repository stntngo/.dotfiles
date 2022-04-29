call plug#begin()

" Global Start Menu
Plug 'mhinz/vim-startify'

" Visuals
Plug 'cocopon/iceberg.vim'
Plug 'vim-airline/vim-airline'

" Universal Plugins
Plug 'tpope/vim-commentary'
Plug 's1n7ax/nvim-terminal'

Plug 'neovim/nvim-lspconfig'
Plug 'unblevable/quick-scope'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" NOTE (niels): This might causing a high amount of memory
" usage in the go-code monorepo, so I'm going to turn it off
" for a while.
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
Plug 'junegunn/fzf.vim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'j-hui/fidget.nvim'

" Completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Language Specific Plugins

" Go
Plug 'fatih/vim-go'

" Python
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
Plug 'vimwiki/vimwiki'
Plug 'tsandall/vim-rego'

" Parsing
Plug 'killphi/vim-ebnf'
Plug 'dylon/vim-antlr'
Plug 'pest-parser/pest.vim'
Plug 'gf3/peg.vim'

call plug#end()

" if executable('pyls')
" 	au User lsp_setup call lsp#register_server({
" 		\ 'name': 'pyls',
" 		\ 'cmd': {server_info->['pyls']},
" 		\ 'whitelist': ['python'],
" 		\ })
" endif


" if executable('typescript-language-server')
" 	au User lsp_setup call lsp#register_server({
" 		\ 'name': 'typescript-language-server',
" 		\ 'cmd': {server_info->['typescript-language-server', '--stdio']},
" 		\ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
" 		\ 'whitelist': ['javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx'],
" 		\ })
" endif

" if executable('flow')
" 	au User lsp_setup call lsp#register_server({
" 		\ 'name': 'flow',
" 		\ 'cmd': {server_info->['flow', 'lsp', '--from', 'vim-lsp']},
" 		\ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.flowconfig'))},
" 		\ 'whitelist': ['javascript', 'javascript.jsx'],
" 		\ })
" endif

" if executable('ocamllsp')
" 	au User lsp_setup call lsp#register_server({
" 		\ 'name': 'ocamllsp',
" 		\ 'cmd': {server_info->['ocamllsp']},
" 		\ 'whitelist': ['ocaml'],
" 		\ })
" endif

colorscheme iceberg
set t_8f=^[[38;2;%lu;%lu;%lum
set t_8b=^[[38;2;%lu;%lu;%lum
let g:javascript_plugin_flow = 1

" let $EDITOR = 'nvr -cc split --remote-wait'

lua require('aniseed.env').init()
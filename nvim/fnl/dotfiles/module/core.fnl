(module dotfiles.module.core
  {require {nvim aniseed.nvim
            util dotfiles.util}})

(set nvim.o.mousehide true)
(set nvim.o.number true)
(set nvim.o.relativenumber true)
(set nvim.o.showmatch true)
(set nvim.o.termguicolors true)

(vim.cmd "colorscheme iceberg")

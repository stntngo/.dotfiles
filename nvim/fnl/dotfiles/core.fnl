(module dotfiles.core
  {require {nvim  aniseed.nvim
            util  dotfiles.util
            color dotfiles.colors}})

(set nvim.o.mousehide true)
(set nvim.o.number true)
(set nvim.o.relativenumber true)
(set nvim.o.showmatch true)
(set nvim.o.termguicolors true)

(vim.cmd "colorscheme nordfox")

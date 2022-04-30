(module dotfiles.module.core
  {require {nvim aniseed.nvim
            util dotfiles.util}})

(set nvim.o.mousehide true)
(set nvim.o.number true)
(set nvim.o.relativenumber true)
(set nvim.o.showmatch true)
(set nvim.o.termguicolors true)

; TODO (niels): Put this in a better place rather than
; just shoving it in here.
(let [colorizer (require :colorizer)]
  (colorizer.setup))

(vim.cmd "colorscheme iceberg")

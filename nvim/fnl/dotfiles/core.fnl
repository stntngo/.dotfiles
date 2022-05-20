(module dotfiles.core
  {require {nvim  aniseed.nvim
            util  dotfiles.util
            color dotfiles.colors}})

(vim.cmd "colorscheme nordfox")

(set nvim.o.mousehide true)
(set nvim.o.number true)
(set nvim.o.showmatch true)
(set nvim.o.termguicolors true)

; NOTE: I don't know how I feel about this yet...
; I've switched back and forth between relativenumber
; and normal numbers historically and I really don't
; feel strongly one way or the other.
(set nvim.o.relativenumber false)

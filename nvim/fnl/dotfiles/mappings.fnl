(module dotfiles.mappings
  {require {nvim aniseed.nvim
            core aniseed.core}})

(set nvim.g.mapleader ",")
(set nvim.g.maplocalleader "\\")

; jj will pop the terminal back out to normal mode
; (vim.keymap.set :t :jj :<c-\><c-n>)

; jj in insert mode for quickly getting back to normal mode. 
(vim.keymap.set :i :jj :<esc>)

; I don't really use macros and right now tend to accidentally triggermacro
; macro recording so let's just shut that off.
(vim.keymap.set :n :q :<nop>)

; <leader><space> will clear any potential highlights from the buffers.
(vim.keymap.set :n :<leader><space> "<cmd>noh<cr>")

; <leader>u will toggle the undotree buffer on the left side of the window. 
; The cursor will focus the newly created buffer if the toggle action shows
; the buffer.
(vim.keymap.set :n :<leader>u :<cmd>UndotreeToggle<cr>)
(set nvim.g.undotree_SetFocusWhenToggle 1)
(set nvim.g.undotree_WindowLayout 2)
